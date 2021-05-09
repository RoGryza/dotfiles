local HOME = os.getenv('HOME')

vim.cmd 'filetype plugin indent on'
vim.cmd 'syntax on'

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.o.copyindent = true
vim.o.smartindent = true

vim.o.formatoptions = vim.o.formatoptions .. 't'

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.lazyredraw = true
vim.g.nofoldenable = true
vim.wo.number = true
vim.o.showcmd = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wildmenu = true
vim.o.wildmode = 'longest,list'
vim.g.noshowmode = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.smartcase = true

dirs = {
  undodir = 'undo',
  backupdir =  'backup',
  directory = 'swap',
}
for option, dir in pairs(dirs) do
  local full = HOME .. '/.cache/nvim/' .. dir .. '//'
  vim.o[option] = full
  os.execute('mkdir -p ' .. full)
end

vim.o.backupskip = '/tmp/*'
vim.o.backup = true
vim.o.writebackup = true
vim.g.noswapfile = true

vim.o.clipboard = 'unnamed'

-- Persist (g)undo tree between sessions
vim.o.undofile = true
vim.o.history = 4096
vim.o.undolevels = 4096

vim.highlight.on_yank()
vim.o.colorcolumn = "100"
-- TODO avoid cmd?
vim.cmd('highlight ColorColumn ctermbg=darkgray')

vim.o.scrolloff = 10
