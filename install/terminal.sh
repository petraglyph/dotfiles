#!/bin/sh
# Configure Command Line
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
LOC="$HOME/.dotfiles"

# Check install location
$(dirname $(readlink -f $0))/check.sh "none"
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


printf "\033[1;32m%s\033[0m\n" "Linking Terminal Configs"
ln -fs $LOC/configs/profile $HOME/.profile
ln -fs $LOC/configs/aliasrc $HOME/.aliasrc
ln -fs $LOC/configs/bashrc $HOME/.bashrc
ln -fs $LOC/configs/vimrc $HOME/.vimrc

# Link configs if commands are present
if [ ! -z "$(command -v zsh)" ]; then
	ln -fs $LOC/configs/zshrc $HOME/.zshrc
fi
if [ ! -z "$(command -v fish)" ]; then
	mkdir -p $XDG_CONFIG_HOME/fish
	ln -fs $LOC/configs/fish/config.fish $HOME/.config/fish/config.fish
	for script in $LOC/configs/fish/0*; do
		ln -fs $script $HOME/.config/fish/conf.d/$(basename $script)
	done
fi
if [ ! -z "$(command -v git)" ]; then
	mkdir -p $XDG_CONFIG_HOME/git
	ln -fs $LOC/configs/git/config $XDG_CONFIG_HOME/git/config
	ln -fs $LOC/configs/git/ignore $XDG_CONFIG_HOME/git/ignore
	cp $LOC/configs/git/email.sample $XDG_CONFIG_HOME/git/email.sample
fi
if [ ! -z "$(command -v nvim)" ]; then
	mkdir -p $XDG_CONFIG_HOME/nvim
	mkdir -p $XDG_DATA_HOME/nvim/site/colors
	mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes
	ln -fs $LOC/configs/nvim.init.lua $XDG_CONFIG_HOME/nvim/init.lua
	ln -fs $LOC/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
	ln -fs $LOC/configs/maia-custom-airline.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim
fi
if [ ! -z "$(command -v ranger)" ]; then
	rm -rf $HOME/.config/ranger
	ln -fs $LOC/configs/ranger -T $XDG_CONFIG_HOME/ranger
fi
if [ ! -z "$(command -v lf)" ]; then
	mkdir -p $XDG_CONFIG_HOME/lf
	ln -fs $LOC/configs/lfrc $XDG_CONFIG_HOME/lf/lfrc
	ln -fs $LOC/configs/lfcolors $XDG_CONFIG_HOME/lf/colors
fi
if [ ! -z "$(command -v zellij)" ]; then
	mkdir -p $XDG_CONFIG_HOME/zellij
	ln -fs $LOC/configs/zellij.kdl $XDG_CONFIG_HOME/zellij/config.kdl
	ln -fs $LOC/configs/zellij-layouts -T $XDG_CONFIG_HOME/zellij/layouts
fi


# Setup fish if available
if [ ! -z "$(grep fish /etc/shells)" ]; then
	printf "\033[1;32m%s\033[0m\n" "Enabling fish"
	if [ "$(basename $SHELL)" != "fish" ]; then
		chsh -s /usr/bin/fish
	fi
fi
