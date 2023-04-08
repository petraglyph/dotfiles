#!/bin/sh
# Configure for Desktop Use
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


# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp
mkdir -p $XDG_CONFIG_HOME/gtk-3.0
mkdir -p $XDG_CONFIG_HOME/alacritty

printf "\033[1;32m%s\033[0m\n" "Linking Desktop Configs"
ln -fs $LOC/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $LOC/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $LOC/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $LOC/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-3.0/settings.ini
ln -fs $LOC/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs
ln -fs $LOC/configs/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
