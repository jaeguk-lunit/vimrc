"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requires that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Enable native vim packages as described in the README
""""""""""""""""""""""""""""""
set packpath+=~/.vim_runtime


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h')."/.."
call pathogen#infect(s:vim_runtime.'/plugins/{}')
call pathogen#helptags()


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated venv .venv'
set grepprg=/usr/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '.pytest_cache']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
map <leader>nr :NERDTreeRefreshRoot<cr>

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'relativepath', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale (syntax checker and linter)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'python': ['ruff'],
\   'cpp': ['clangd']
\}

let g:ale_fixers = {
\   'python': ['ruff', 'ruff_format'],
\   'cpp': ['clangd']
\} 

let g:ale_python_ruff_options = '--select E,F,W,I,UP --line-length 100'

nmap <silent> <leader>a <Plug>(ale_next_wrap)

" Disabling highlighting
let g:ale_set_highlights = 1

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_virtualtext_cursor = 'disabled'

"ALEFix
nnoremap <leader>a <Plug>(ale_fix) :ALEFix<Return>
" Fix files when saving file
" let g:ale_fix_on_save = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=1
set updatetime=50
autocmd ColorScheme * highlight! link SignColumn LineNr
set signcolumn=yes


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy the link to the line of a Git repository to the clipboard
nnoremap <leader>v :.GBrowse!<CR>
xnoremap <leader>v :GBrowse!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Asyncomplete-lsp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable tab for selecting from suggestion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LSP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP default keymap
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>d <plug>(lsp-definition)
    nmap <buffer> <leader>s <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>S <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>r <plug>(lsp-references)
    nmap <buffer> <leader>i <plug>(lsp-implementation)
    nmap <buffer> <leader>t <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>[ <plug>(lsp-previous-diagnostic)
    nmap <buffer> <leader>] <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <expr><buffer> <c-d> popup_list()->empty() ? '<c-d>' : lsp#scroll(+4)
    nmap <expr><buffer> <c-u> popup_list()->empty() ? '<c-u>' : lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

"How to load diagnostic meesage
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 500
let g:lsp_document_code_action_signs_hint = {'text': ' '}

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
