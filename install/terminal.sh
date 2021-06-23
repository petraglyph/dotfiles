#!/bin/bash
# Terminal Configuration

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
source "$(dirname $BASH_SOURCE)/check.sh" "$comp"

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
mkdir -p $XDG_DATA_HOME/nvim/site/colors
mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes

message "Linking Terminal Configs"
ln -fs $loc/configs/gitconfig $XDG_CONFIG_HOME/git/config
ln -fs $loc/configs/gitignore $XDG_CONFIG_HOME/git/ignore
ln -fs $loc/configs/nvim.init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -fs $loc/configs/ranger $XDG_CONFIG_HOME/ranger
ln -fs $loc/configs/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
ln -fs $loc/configs/profile $HOME/.profile
ln -fs $loc/configs/zshrc $HOME/.zshrc
ln -fs $loc/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
ln -fs $loc/configs/airline-maia_custom.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim

if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim +PlugInstall +qall


message "Root Zsh Config"
sudo rm -f /root/.zshrc
sudo cp -f $loc/configs/zshrc-root /root/.zshrc

message "Setting Up Zsh"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh
if [ -f $loc/$comp/zsh-dirs ]; then
	ln -fs $loc/$comp/zsh-dirs $HOME/.zsh-dirs
fi


message "Setting up Crontab"
if [ $(command -v sass) ]; then
	sudo crontab $loc/configs/sudo-crontab.txt
else
	echo "@daily rm -rf \$(find /var/cache/ -type f -mtime +30 -print)" | sudo crontab -
fi
if [ -f $loc/$comp/crontab.txt ]; then
	crontab $loc/$comp/crontab.txt
else
	crontab $loc/configs/crontab.txt
fi
