local M = {}

function M.startup(use)
  local langs = {
    require('lang/lua'),
    require('lang/rust'),
    require('lang/typescript'),
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
    'hrsh7th/nvim-compe',
    config = function()
      vim.o.completeopt = 'menuone,noselect'
      require'compe'.setup {
        enabled = true;
        preselect = 'disable';

        source = {
          path = true;
          buffer = true;
          nvim_lsp = true;
          nvim_lua = true;
        },
      }

      -- Use (s-)tab to move to prev/next item in completion menuone
      -- Copied from nvim-compe README
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          return true
        else
          return false
        end
      end

      _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-n>"
        elseif check_back_space() then
          return t "<Tab>"
        else
          return vim.fn['compe#complete']()
        end
      end

      _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-p>"
        else
          return t "<S-Tab>"
        end
      end
      vim.api.nvim_set_keymap("i", "<C-space>", "compe#complete()", {expr = true})
      vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
      vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
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
  end

  -- TODO: autoinstall missing servers
  function _G.setup_servers()
    local lspconfig = require'lspconfig'
    for _, cfg in ipairs(langs) do
      if cfg.lsp_servers ~= nil then
        for server, server_cfg in pairs(cfg.lsp_servers) do
          local finalcfg = { on_attach = on_attach }
          if server_cfg.on_attach ~= nil then
            finalcfg.on_attach = function(...)
              on_attach(...)
              server_cfg.on_attach(...)
            end
          end
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
  autocmd!
  autocmd VimEnter * lua setup_servers()
  augroup END
  ]]
end

return M
