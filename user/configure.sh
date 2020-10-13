#!/bin/bash
# Added user

loc="$HOME/.dotfiles"

if (( $# < 1 )); then
	echo "User required"
	exit 1
fi
if [ ! -d $loc/user/$1 ]; then
	echo "Unkowm user '$user'"
	exit 1
fi
user=$1

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi
if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME=$HOME/.local/share
fi

echo "Configuring"

# Making necessary directories
rm -rf $HOME/.config/ranger
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_DATA_HOME/nvim/site/colors
mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes

# Linking configs
ln -fs $loc/user/$user/gitconfig $XDG_CONFIG_HOME/git/config
ln -fs $loc/configs/nvim.init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -fs $loc/configs/ranger $XDG_CONFIG_HOME/ranger
#ln -fs $loc/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs
ln -fs $loc/configs/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
ln -fs $loc/configs/profile $HOME/.profile
ln -fs $loc/user/$user/zshrc $HOME/.zshrc
#ln -fs $loc/$comp/zsh-dirs $HOME/.zsh-dirs
echo "" > $HOME/.zsh-dirs
ln -fs $loc/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
ln -fs $loc/configs/airline-maia_custom.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim

# Install Vim Plug
if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
