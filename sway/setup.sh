#!/bin/sh
# Configure i3
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="$1"

# Check install location and comp
. "$(dirname $(readlink -f $0))/../install/check.sh" "$comp"

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi
if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME=$HOME/.local/share
fi

message "tty1 login"
echo '[ "$(tty)" = "/dev/tty1" ] && exec sway' > $HOME/.zlogin

# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/sway
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/waybar
mkdir -p $XDG_CONFIG_HOME/environment.d
mkdir -p $XDG_CONFIG_HOME/zathura

message "Linking Configs"
ln -fs $loc/$comp/sway-config $XDG_CONFIG_HOME/sway/config
ln -fs $loc/$comp/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
ln -fs $loc/sway/configs/waybar $XDG_CONFIG_HOME/waybar/config
ln -fs $loc/sway/configs/waybar.css $XDG_CONFIG_HOME/waybar/style.css
ln -fs $loc/sway/configs/envvars.conf $XDG_CONFIG_HOME/environment.d/envvars.conf
ln -fs $loc/sway/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc

message "Adding Font"
mkdir -p $XDG_DATA_HOME/fonts
cp -f $loc/sway/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf
