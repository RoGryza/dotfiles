-- Source: https://icyphox.sh/blog/nvim-lua/
local M = {}

function M.augroup(name, autocmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('augroup!')
  for _, autocmd in ipairs(autocmds) do
    vim.cmd('autocmd ' .. table.concat(autocmd, ' '))
  end
  vim.cmd('augroup END')
end
