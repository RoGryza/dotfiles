-- show trailing whitespaces
vim.o.list = true
vim.o.listchars = 'tab:▸\\ ,trail:¬,nbsp:.,extends:❯,precedes:❮'

-- TODO lua
vim.o.guifont = 'DejaVuSansMono Nerd Font Mono:h16'
vim.cmd [[
augroup ListChars2
 au!
 autocmd filetype go set listchars+=tab:\ \ 
 autocmd ColorScheme * hi! link SpecialKey Normal
augroup end
]]

-- Incremental substitution
vim.o.inccommand = 'nosplit'

vim.cmd [[colorscheme base16]]
