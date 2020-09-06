#!/bin/bash
# Configure i3

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

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

echo "Linking Configs"
ln -fs $loc/$comp/i3-config $XDG_CONFIG_HOME/i3/config
ln -fs $loc/$comp/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
ln -fs $loc/i3/configs/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
ln -fs $loc/i3/configs/polybar $XDG_CONFIG_HOME/polybar/config
ln -fs $loc/i3/configs/rofi-config $XDG_CONFIG_HOME/rofi/config
ln -fs $loc/i3/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc
ln -fs $loc/i3/configs/stalonetrayrc $HOME/.stalonetrayrc
ln -fs $loc/$comp/Xresources $HOME/.Xresources

echo "Adding Font"
cp -f $loc/i3/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf

echo "Configuring Xorg"
sudo rm -rf /etc/X11/xorg.conf.d
sudo cp -rf $loc/$comp/xorg /etc/X11/xorg.conf.d

echo "Compiling brightcalc.c"
gcc -O2 $loc/i3/scripts/brightcalc.c -o $loc/.local/brightcalc

# Adding local directory
mkdir -p $loc/.local
