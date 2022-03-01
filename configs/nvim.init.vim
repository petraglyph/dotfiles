" NeoVim Config
" Penn Bauman <me@pennbauman.com>

" From default vimrc
set scrolloff=5
" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
au!
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
	\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
	\ |   exe "normal! g`\""
	\ | endif
augroup END



" General
filetype plugin on
set encoding=utf8
set clipboard+=unnamedplus

" Appearance
set number
set wrap lbr
set tabstop=4
set softtabstop=4
set shiftwidth=4
set listchars=tab:¦\ ,trail:~,extends:>,precedes:<
set list
set guicursor=
source $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
" Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Set spellcheck
autocmd FileType markdown setlocal spell
autocmd FileType tex setlocal spell
autocmd FileType text setlocal spell

" Text conceal
set conceallevel=1
set concealcursor=
au BufLeave * call clearmatches()
"au BufEnter * call matchadd('Conceal', '<=', 10, 199, {'conceal': '≤'})
"au BufEnter * call matchadd('Conceal', '>=', 10, 198, {'conceal': '≥'})
"au BufEnter * call matchadd('Conceal', '!=', 10, 197, {'conceal': '≠'})
" Python
"   Ƨ⊡⌽⚴
au BufEnter *.py call matchadd('Conceal', 'self', 10, 99, {'conceal': '⚴'})
" HTML
au BufEnter *.html call matchadd('Conceal', '&amp;', 10, 99, {'conceal': '&'})
au BufEnter *.html call matchadd('Conceal', '&apos;', 10, 98, {'conceal': '’'})
au BufEnter *.html call matchadd('Conceal', '&copy;', 10, 97, {'conceal': '©'})
" PHP
au BufEnter *.php call matchadd('Conceal', '&amp;', 10, 99, {'conceal': '&'})
au BufEnter *.php call matchadd('Conceal', '&apos;', 10, 98, {'conceal': '’'})
au BufEnter *.php call matchadd('Conceal', '&copy;', 10, 97, {'conceal': '©'})



" Keyboard Shortcuts
nnoremap <S-tab> :bprev<Enter>
nnoremap <tab>   :bnext<Enter>
" Document navigation
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> <S-h> g^
noremap <silent> <S-j> 15gj
noremap <silent> <S-k> 15gk
noremap <silent> <S-l> g$
nmap <S-u> :redo<Enter>
" Editing
nmap <enter> o<esc>
nmap ; :
nmap < v<
nmap > v>
vmap <S-y> ! xsel -b<enter>u
command! Tabify :%s/    /\t/g
command! Spacify :%s/\t/    /g
command! TexWC :w !detex | wc -w
" Terminal
nnoremap <C-t> :terminal<Enter>i<end>
au TermOpen * setlocal nonumber



" Plugins (vim-plug)
call plug#begin('~/.config/nvim/plugged')
	Plug 'https://github.com/vim-airline/vim-airline.git'
	Plug 'https://github.com/Lokaltog/neoranger'
	Plug 'scrooloose/nerdcommenter'
	Plug 'lervag/vimtex'
	Plug 'nvim-lua/completion-nvim'
	Plug 'steelsojka/completion-buffers'
call plug#end()


" completion-nvim
autocmd BufEnter * lua require'completion'.on_attach()
set completeopt=menuone,noinsert,noselect
set shortmess+=c
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" Set completion sources
let g:completion_chain_complete_list = [{'complete_items':
	\['buffer', 'buffers', 'path']}]
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" vim-airline
let g:airline_theme='maia_custom'
let g:airline#extensions#tabline#enabled = 1


" neoranger
let g:neoranger_viewmode='miller'
nnoremap <C-r> :RangerCurrentFile<Enter>


" nerdcommenter
nmap c V\ci
vmap c \cc
let g:NERDCustomDelimiters = {
	\ 'c': {'left': '//', 'right': ''},
	\ 'python': {'left': '#', 'right': ''}
	\ }


" VimTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='mg'
"abdmg
nnoremap <C-l> :VimtexCompile<Enter>
