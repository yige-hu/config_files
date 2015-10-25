syntax on
set background=dark
set shiftwidth=2
set expandtab
set tabstop=2

if has("autocmd")
  filetype plugin indent on
endif

set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
set incsearch           " Incremental search
set hidden              " Hide buffers when they are abandoned
set cursorline
set hlsearch

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Uncomment the following to have Vim jump to the last position when                                                       
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
