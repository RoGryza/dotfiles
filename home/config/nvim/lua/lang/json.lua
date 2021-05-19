return function(use)
  -- jsonc syntax
  vim.cmd [[
  augroup MyJson
    au!
    au FileType json syntax match Comment +\/\/.\+$+
  augroup END
  ]]
end
