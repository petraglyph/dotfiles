#!/bin/sh
# Configure i3
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
$(dirname $(readlink -f $0))/../install/check.sh "$comp"
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
mkdir -p $XDG_CONFIG_HOME/i3
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/dunst
mkdir -p $XDG_CONFIG_HOME/polybar
mkdir -p $XDG_CONFIG_HOME/rofi
mkdir -p $XDG_CONFIG_HOME/zathura
mkdir -p $XDG_DATA_HOME/fonts

printf "\033[1;32m%s\033[0m\n" "[i3] Linking Configs"
ln -fs $loc/$comp/i3-config $XDG_CONFIG_HOME/i3/config
ln -fs $loc/$comp/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
ln -fs $loc/i3/configs/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
ln -fs $loc/i3/configs/polybar $XDG_CONFIG_HOME/polybar/config
ln -fs $loc/i3/configs/rofi-theme.rasi $XDG_CONFIG_HOME/rofi/config.rasi
ln -fs $loc/i3/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc
ln -fs $loc/i3/configs/stalonetrayrc $HOME/.stalonetrayrc
ln -fs $loc/$comp/Xresources $HOME/.Xresources

printf "\033[1;32m%s\033[0m\n" "[i3] Adding Font"
cp -f $loc/i3/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf

printf "\033[1;32m%s\033[0m\n" "[i3] Configuring Xorg"
sudo rm -rf /etc/X11/xorg.conf.d
sudo cp -rf $loc/$comp/xorg /etc/X11/xorg.conf.d
