#!/bin/sh
# Configure for Terminal Use
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
$(dirname $(readlink -f $0))/check.sh "$comp"
if [ $? -ne 0 ]; then
	exit 1
fi

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi
if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME=$HOME/.local/share
fi


# Making necessary directories
rm -rf $HOME/.config/ranger
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_CONFIG_HOME/lf
mkdir -p $XDG_CONFIG_HOME/zellij
mkdir -p $XDG_DATA_HOME/nvim/site/colors
mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes

printf "\033[1;32m%s\033[0m\n" "Linking Terminal Configs"
ln -fs $loc/configs/git/config $XDG_CONFIG_HOME/git/config
ln -fs $loc/configs/git/ignore $XDG_CONFIG_HOME/git/ignore
cp $loc/configs/git/email.sample $XDG_CONFIG_HOME/git/email.sample
ln -fs $loc/configs/ranger $XDG_CONFIG_HOME/ranger
ln -fs $loc/configs/profile $HOME/.profile
ln -fs $loc/configs/aliasrc $HOME/.aliasrc
ln -fs $loc/configs/bashrc $HOME/.bashrc
ln -fs $loc/configs/zshrc $HOME/.zshrc
ln -fs $loc/configs/vimrc $HOME/.vimrc
ln -fs $loc/configs/nvim.init.lua $XDG_CONFIG_HOME/nvim/init.lua
ln -fs $loc/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
ln -fs $loc/configs/maia-custom-airline.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim
ln -fs $loc/configs/lfrc $XDG_CONFIG_HOME/lf/lfrc
ln -fs $loc/configs/lfcolors $XDG_CONFIG_HOME/lf/colors
ln -fs $loc/configs/zellij.kdl $XDG_CONFIG_HOME/zellij/config.kdl

# Setup zsh if available
if [ -f /usr/bin/zsh ]; then
	printf "\033[1;32m%s\033[0m\n" "Setting Up Zsh"
	if [ "$(basename $SHELL)" != "zsh" ]; then
		chsh -s /usr/bin/zsh
	fi
	if [ -f $loc/$comp/zsh-dirs ]; then
		ln -fs $loc/$comp/zsh-dirs $HOME/.zsh-dirs
	fi
fi
