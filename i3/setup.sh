#!/bin/sh
# Configure i3
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
LOC="$HOME/.dotfiles"
COMP="$1"

# Check install location and computer
$(dirname $(realpath $0))/../install/check.sh "$COMP"
if [ $? -ne 0 ]; then
	exit 1
fi


# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/i3
mkdir -p $XDG_CONFIG_HOME/dunst
mkdir -p $XDG_CONFIG_HOME/polybar
mkdir -p $XDG_CONFIG_HOME/rofi
mkdir -p $XDG_CONFIG_HOME/zathura
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp
mkdir -p $XDG_CONFIG_HOME/gtk-3.0
mkdir -p $XDG_DATA_HOME/fonts

printf "\033[1;32m%s\033[0m\n" "[i3] Linking Configs"
ln -fs $LOC/$COMP/i3-config $XDG_CONFIG_HOME/i3/config
ln -fs $LOC/i3/configs/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
ln -fs $LOC/i3/configs/polybar.ini $XDG_CONFIG_HOME/polybar/config.ini
ln -fs $LOC/i3/configs/rofi-theme.rasi $XDG_CONFIG_HOME/rofi/config.rasi
ln -fs $LOC/i3/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc
ln -fs $LOC/configs/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml
ln -fs $LOC/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $LOC/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $LOC/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $LOC/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs
ln -fs $LOC/i3/configs/xinitrc $HOME/.xinitrc
ln -fs $LOC/i3/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-3.0/settings.ini
ln -fs $LOC/$COMP/Xresources $HOME/.Xresources

printf "\033[1;32m%s\033[0m\n" "[i3] Adding Font"
cp -f $LOC/i3/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf

printf "\033[1;32m%s\033[0m\n" "[i3] Configuring Xorg"
sudo rm -rf /etc/X11/xorg.conf.d
sudo cp -rf $LOC/$COMP/xorg /etc/X11/xorg.conf.d

printf "\033[1;32m%s\033[0m\n" "[i3] Adding tty1 autostart"
echo '# Start X at login
if status is-login
        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
                startx
        end
end' > $XDG_CONFIG_HOME/fish/conf.d/startx.fish
