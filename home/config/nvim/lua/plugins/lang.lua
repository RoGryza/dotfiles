local M = {}

function M.startup(use)
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      -- Give more space for displaying messages.
      vim.g.cmdheight = 2
      -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      -- delays and poor user experience.
      vim.g.updatetime = 300
      -- Don't pass messages to |ins-completion-menu|.
      vim.cmd [[ set shortmess+=c ]]

      local function noremap(mode, before, after, opts)
        local fullopts = vim.tbl_extend(
          "keep",
          {},
          opts or {},
          { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap(mode, before, after, fullopts)
      end

      local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local function checkpopup(visible, notvisible, call)
        local function cb()
          if vim.fn.pumvisible() == 1 then
            if call then return visible() else return visible end
          else
            return notvisible
          end
        end
        return cb
      end

      noremap('i', '<C-space>', 'coc#refresh()', { expr = true })
      -- TODO rewrite this in lua
      vim.cmd [[ inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>" ]]
      _G.my_tab_cb = checkpopup(t '<C-n>', t '<Tab>')
      noremap('i', '<Tab>', "v:lua.my_tab_cb()", { expr = true, silent = false })
      _G.my_stab_cb = checkpopup(t '<C-p>', t '<S-Tab>')
      noremap('i', '<S-Tab>', "v:lua.my_stab_cb()", { expr = true, silent = false })

      -- TODO rewrite below in lua
      vim.cmd [[
      echom 'WTFFFFF'
      nnoremap gD <Plug>(coc-declaration)
      echom 'WTFFFFF'
      ]]
      -- noremap('n', 'ga', '<Plug>(coc-codeaction-cursor)', { silent = false })
      -- noremap('v', 'ga', '<Plug>(coc-codeaction-cursor)', { silent = false })
      -- noremap('i', '<C-.>', '<Plug>(coc-codeaction-cursor)', { silent = false }) -- TODO check this
      -- noremap('n', 'gr', '<Plug>(coc-rename)', { silent = false })
    end,
  }

  -- TODO manage coc extensions
  local langs = {
    require('lang/json'),
    -- require('lang/simple'),
    -- require('lang/haxe'),
    -- require('lang/lua'),
    -- require('lang/rust'),
    -- require('lang/typescript'),
  }

  for _, lang in ipairs(langs) do
    -- lang(use)
  end
end

return
