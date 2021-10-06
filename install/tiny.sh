#!/bin/bash
# Install Basic Bash Setup
#   Penn Bauman <me@pennbauman.com>

if [ $(command -v apt) ]; then
	sudo apt install -y vim ranger
elif [ $(command -v yum) ]; then
	sudo yum install -y vim ranger
else
	echo -e "\033[31mUnkown package manager\033[0m"
fi

# Improve bash history and autocomplete
if [ ! -f $HOME/.inputrc ] || [ -z "$(grep '"\e[A":history-search-backward' $HOME/.inputrc)" ]; then
	echo '# arrow up
"\e[A":history-search-backward
# arrow down
"\e[B":history-search-forward
# ignore cases for auto-complete
set completion-ignore-case on' >> $HOME/.inputrc
fi

# Add vimrc
if [ -f $home/.vimrc ]; then
	mv $home/.vimrc $home/.vimrc.old
fi
echo -e "\" Put these in an autocmd group, so that you can revert them with:
\" \":augroup vimStartup | au! | augroup END\"
augroup vimStartup
au!
\" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
	\ if line(\"'\\\"\") >= 1 && line(\"'\\\"\") <= line(\"$\") && &ft !~# 'commit'
	\ |   exe \"normal! g\`\\\"\"
	\ | endif
augroup END

\" General
filetype plugin on
set encoding=utf8
set number
set wrap lbr
set tabstop=4
set scrolloff=5
set listchars=tab:¦\ ,trail:~,extends:>,precedes:<
set list
set guicursor=
let g:netrw_banner = 0
let g:netrw_liststyle = 3

\" Keyboard Shortcuts
nnoremap <S-tab> :bprev<Enter>
nnoremap <tab>   :bnext<Enter>
noremap <silent> <S-h> ^
noremap <silent> <S-j> 15j
noremap <silent> <S-k> 15k
noremap <silent> <S-l> $
nmap <S-u> :redo<Enter>
nmap ; :
nmap < v<
nmap > v>
nmap <S-d> dd" > $HOME/.vimrc
