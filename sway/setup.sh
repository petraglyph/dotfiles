#!/bin/sh
# Configure Sway
#   Penn Bauman <me@pennbauman.com>
LOC="$HOME/.dotfiles"
COMP="$1"

# Check install location and computer
$(dirname $(realpath $0))/../install/check.sh "$COMP"
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
mkdir -p $XDG_CONFIG_HOME/sway
mkdir -p $XDG_CONFIG_HOME/waybar
mkdir -p $XDG_CONFIG_HOME/environment.d
mkdir -p $XDG_CONFIG_HOME/zathura

printf "\033[1;32m%s\033[0m\n" "[Sway] Linking Configs"
ln -fs $LOC/$COMP/sway-config $XDG_CONFIG_HOME/sway/config
ln -fs $LOC/sway/configs/waybar $XDG_CONFIG_HOME/waybar/config
ln -fs $LOC/sway/configs/waybar.css $XDG_CONFIG_HOME/waybar/style.css
ln -fs $LOC/sway/configs/envvars.conf $XDG_CONFIG_HOME/environment.d/envvars.conf
ln -fs $LOC/sway/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc

printf "\033[1;32m%s\033[0m\n" "[Sway] Adding Font"
mkdir -p $XDG_DATA_HOME/fonts
cp -f $LOC/sway/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf


printf "\033[1;32m%s\033[0m\n" "[Sway] Adding tty1 autostart"
echo '# Start Sway at login
if status is-login
        if test -z "$DISPLAY" -a "$XDG_VTNR" = 2
                sway
        end
end' > $HOME/.config/fish/conf.d/sway-autostart.fish
