#!/bin/sh
# Configure Sway
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="$1"

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

printf "\033[1;32m%s\033[0m\n" "[Sway] Setting up tty1 login"
echo '[ "$(tty)" = "/dev/tty1" ] && exec sway' > $HOME/.zlogin

# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/sway
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/waybar
mkdir -p $XDG_CONFIG_HOME/environment.d
mkdir -p $XDG_CONFIG_HOME/zathura

printf "\033[1;32m%s\033[0m\n" "[Sway] Linking Configs"
ln -fs $loc/$comp/sway-config $XDG_CONFIG_HOME/sway/config
ln -fs $loc/$comp/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
ln -fs $loc/sway/configs/waybar $XDG_CONFIG_HOME/waybar/config
ln -fs $loc/sway/configs/waybar.css $XDG_CONFIG_HOME/waybar/style.css
ln -fs $loc/sway/configs/envvars.conf $XDG_CONFIG_HOME/environment.d/envvars.conf
ln -fs $loc/sway/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc

printf "\033[1;32m%s\033[0m\n" "[Sway] Adding Font"
mkdir -p $XDG_DATA_HOME/fonts
cp -f $loc/sway/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf
