-- Ensure packer is installed (TODO move this to init.sh)
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

local packer = require('packer')
packer.reset()
return packer.startup({
  function(use)
    use 'wbthomason/packer.nvim'

    use {
      'tpope/vim-commentary',
      'tpope/vim-eunuch',
      'tpope/vim-repeat',
      'tpope/vim-surround',
    }
    -- TODO use ':Telescope registers' instead of registers.nvim
    use {
      'tversteeg/registers.nvim',
      cmd = {'Registers'},
      keys = {'"', {'i', '<C-R>'}},
    }

    use {
      {'tpope/vim-fugitive', cmd = {'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull', 'Gread', 'Gwrite'}},
      {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
          require('gitsigns').setup {
            signs = {
              add = {hl = 'GreenSign', text = '│', numhl = 'GitSignsAddNr'},
              change = {hl = 'BlueSign', text = '│', numhl = 'GitSignsChangeNr'},
              delete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
              topdelete = {hl = 'RedSign', text = '│', numhl = 'GitSignsDeleteNr'},
              changedelete = {hl = 'PurpleSign', text = '│', numhl = 'GitSignsChangeNr'}
            }
          }
        end,
        event = 'BufEnter'
      },
    }

    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
      config = function()
        vim.cmd [[
        " Find files using Telescope command-line sugar.
        nnoremap <C-p> <cmd>Telescope find_files<cr>
        nnoremap <C-b> <cmd>Telescope buffers show_all_buffers=true<cr>
        nnoremap <C-t> <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
        ]]
      end
    }
    use {
      'gbrlsnchs/telescope-lsp-handlers.nvim',
      after = 'telescope.nvim',
      config = function()
        require'telescope'.load_extension('lsp_handlers')
      end
    }

    use {
      'hoob3rt/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require('lualine').setup {} end,
    }

    -- Languages
    require('plugins/lang').startup(use)
    require('plugins/session').startup(use)
  end,
  {
    auto_clean = false,
  }
})
