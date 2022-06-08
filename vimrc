syntax on
set background=dark
set shiftwidth=2
"set expandtab
"set tabstop=2
set autoindent

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

map <C-K> :py3file /usr/share/clang/clang-format-10/clang-format.py<cr>
imap <C-K> <c-o>:py3file /usr/share/clang/clang-format-10/clang-format.py<cr>

function! Formatonsave()
  let l:formatdiff = 1
  py3file /usr/share/clang/clang-format-10/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

" polyglot
let g:polyglot_disabled = ['go', 'python', 'cpp']

" cpp
autocmd FileType c,cpp,h,hpp setlocal expandtab tabstop=2
autocmd Filetype c,cpp,h,hpp set comments^="///,"

" go
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=0 textwidth=80

" python
autocmd FileType py set autoindent
