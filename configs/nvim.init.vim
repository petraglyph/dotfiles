" NeoVim Config
" Penn Bauman

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
set shiftwidth=4
set listchars=tab:¦\ ,trail:~,extends:>,precedes:<
set list
set conceallevel=1
source /home/penn/.local/share/nvim/site/colors/maia-custom.vim

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
nmap <enter> i<enter><esc>
nmap <S-i> i<end>
nmap ; :
nmap < v<
nmap > v>
nmap <S-o> o<esc>
nmap <S-d> dd
vmap <S-y> ! xsel -b<enter>u
" Terminal
nnoremap <C-t> :terminal<Enter>i<end>
tnoremap <C-t> <C-\><C-n>:bnext<enter>
tnoremap <Esc> <C-\><C-n>:bnext<enter>
au TermOpen * setlocal nonumber


" Plugins (vim-plug)
call plug#begin('~/.config/nvim/plugged')
	Plug 'https://github.com/vim-airline/vim-airline.git'
	Plug 'francoiscabrol/ranger.vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'scrooloose/nerdcommenter'
	Plug 'lervag/vimtex'
	Plug 'vimwiki/vimwiki'
call plug#end()

" vim-airline
let g:airline_theme='maia_custom'
let g:airline#extensions#tabline#enabled = 1

" ranger.vim
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 0
nnoremap <C-r> :Ranger<Enter>

" COC.nvim
set hidden
set nobackup
set nowritebackup
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" Use Shift tab for trigger completion with characters ahead and navigate.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
let g:coc_global_extensions=[
	\ "coc-pairs",
	\ "coc-emmet",
	\ "coc-css",
	\ "coc-html",
	\ "coc-phpls",
	\ "coc-json",
	\ "coc-vimtex",
	\ ]

" NERD Commenter
nmap c V\ci
vmap c \cc

" VimTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='mg'
"abdmg
nnoremap <C-l> :VimtexCompile<Enter>

" VimWiki
let g:vimwiki_list = [{
	\ 'path': '~/Storage/linux/vimwiki/',
	\ 'path_html': '~/.vimwiki-html/',
	\ }]
