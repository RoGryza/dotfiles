local M = {}

function M.startup(use)
  local langs = {
    require('lang/lua'),
    require('lang/rust'),
  }
  for _, desc in ipairs(require('lang/simple')) do
    table.insert(langs, desc)
  end

  local treesitterfts = {}
  for _, desc in ipairs(langs) do
    if desc.treesitter and desc.fts then
      for _, ft in ipairs(desc.fts) do
        table.insert(treesitterfts, ft)
      end
    end
  end

  -- Base packages
  use { 'neovim/nvim-lspconfig' }
  use {
    'nvim-lua/completion-nvim',
    requires = 'nvim-lspconfig',
    opt = true,
    config = function()
      vim.cmd [[
      " Use <Tab> and <S-Tab> to navigate through popup menu
      imap <tab> <Plug>(completion_smart_tab)
      imap <s-tab> <Plug>(completion_smart_s_tab)

      " Set completeopt to have a better completion experience
      set completeopt=menuone,noinsert,noselect

      " Avoid showing message extra message when using completion
      set shortmess+=c
      ]]
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    ft = treesitterfts,
    run = ':TSUpdate',
    config = function()
      -- TODO decentralize module configs
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 4096,
        },
        context_commentstring = { enable = true }
      }
      vim.cmd [[
        set nofoldenable
        set foldlevelstart=99
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      ]]
    end
  }
  use {
    'p00f/nvim-ts-rainbow',
    ft = treesitterfts,
    requires = 'nvim-treesitter',
  }
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    ft = treesitterfts,
    requires = 'nvim-treesitter',
  }

  -- Apply lang configs
  local on_attach = function(...)
    require'lang'.on_lsp_attach(...)
    require'packer'.loader('completion-nvim')
    require'completion'.on_attach(...)
  end

  -- TODO: autoinstall missing servers
  function _G.setup_servers()
    local lspconfig = require'lspconfig'
    for _, cfg in ipairs(langs) do
      if cfg.lsp_servers ~= nil then
        for server, server_cfg in pairs(cfg.lsp_servers) do
          local finalcfg = { on_attach = on_attach }
          for k, v in pairs(server_cfg) do
            finalcfg[k] = v
          end
          lspconfig[server].setup(finalcfg)
        end
      end
    end
  end

  for _, cfg in ipairs(langs) do
    if cfg.plugins ~= nil then
      use(cfg.plugins)
    end
  end

  vim.cmd [[
  augroup afterPacker
    au!
    au User PackerComplete lua setup_servers()
  augroup END
  ]]
end

return M
