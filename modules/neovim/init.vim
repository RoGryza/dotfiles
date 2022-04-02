filetype plugin indent on
syntax on

let g:mapleader=','

augroup vimConf
  au!
  " Useful for editing vim source scripts
  autocmd BufEnter *.vim nnoremap <silent><buffer> <Leader>so :exec 'source '.bufname('%') \| echo 'Sourced '.bufname('%')<CR>
augroup END

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set copyindent
set smartindent

set formatoptions+=t

set hlsearch
set incsearch
set lazyredraw
set nofoldenable
set number
set signcolumn=yes
set showcmd
set splitbelow
set splitright
set wildmenu
set wildmode=longest,list
set noshowmode
set hidden
set ignorecase
set smartcase

set undodir=$HOME/.cache/nvim/undo//
call mkdir(&undodir, "p")
set backupdir=$HOME/.cache/nvim/backup//
call mkdir(&backupdir, "p")
set directory=$HOME/.cache/nvim/swap//
call mkdir(&directory, "p")

set backupskip="/tmp/*"
set backup
set writebackup
set noswapfile

set clipboard=unnamed
if exists('g:loaded_clipboard_provider')
  " unlet g:loaded_clipboard_provider
  runtime 'autoload/provider/clipboard.vim'
endif

" Persist (g)undo tree between sessions
set undofile
set history=4096
set undolevels=4096

set textwidth=100
set colorcolumn=+1
highlight ColorColumn ctermbg=darkgray

set scrolloff=10

" Show trailing whitespace
set list
set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮

set guifont="Fira Code Nerd Font Complete Mono:h16"
augroup ListChars2
 au!
 autocmd filetype go set listchars+=tab:\ \ 
 autocmd ColorScheme * hi! link SpecialKey Normal
augroup end

set inccommand=nosplit
colorscheme base16

" Fix S-Insert
map <S-Insert> <MiddleMouse>

"Keep search results at the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

"Navigation mappings
nnoremap j gj
nnoremap k gk

nnoremap <Leader>e <Cmd>bn<CR>
nnoremap <Leader>q <Cmd>bp<CR>
nnoremap <Leader>bd <Cmd>silent! bp<bar>sp<bar>silent! bn<bar>bd<CR>
nnoremap <Leader>w <Cmd>w<CR>

nnoremap <Leader><space> <Cmd>nohlsearch<CR>
nnoremap <space> za
