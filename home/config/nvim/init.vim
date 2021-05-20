let g:mapleader=','

augroup vimConf
  au!
  " Useful for editing vim source scripts
  autocmd BufEnter *.vim nnoremap <silent><buffer> <Leader>so :exec 'source '.bufname('%') \| echo 'Sourced '.bufname('%')<CR>
augroup END

packadd my-plugins
