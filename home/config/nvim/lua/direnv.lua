-- direnv .lvimrc integration
-- TODO lua lol
_G.direnv_init = function()
  vim.api.nvim_exec([[
  if exists("$EXTRA_VIM")
    for path in split($EXTRA_VIM, ':')
      exec "source ".path
    endfor
  endif
  ]], false)
end

vim.cmd [[
augroup direnv
  au!
  autocmd VimEnter * call v:lua.direnv_init()
augroup END
]]
