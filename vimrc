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
set number

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
  py3file /usr/share/clang/clang-format-12/clang-format.py
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
autocmd FileType py set autoindent noexpandtab

" plugins

hi LspError ctermfg=Red
hi LspWarning ctermfg=Yellow

call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-fugitive'

call plug#end()

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
		    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
		    \ 'allowlist': ['.c', '.cpp', 'objc', '.cc', '.tpp', '.t'],
                    \ })
    augroup end
endif

function! s:on_lsp_buffer_enabled() abort
    set signcolumn=yes:1
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <C-x> <plug>(lsp-code-action)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

let g:lsp_document_code_action_signs_hint = {'text': ' »'}
let g:lsp_diagnostics_signs_warning = {'text': ' ⚠'}
let g:lsp_diagnostics_signs_error = {'text': ' ✗'}

function! KatanaNodeEdgeHighlighting()
  if (stridx(expand('%:p'), 'katana') >= 0)
    " absolute path of open buffer contains the word "katana"
    syn match katanaNode /node\|Node/
    syn match katanaEdge /edge\|Edge/
    hi katanaNode cterm=bold ctermfg=Magenta
    hi katanaEdge cterm=bold ctermfg=Red
  endif
endfunction()

" Call this function every time a color scheme is loaded
autocmd bufenter * :call KatanaNodeEdgeHighlighting()
autocmd filetype * :call KatanaNodeEdgeHighlighting()
