#!/bin/sh
# Configure Sway
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
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
mkdir -p $XDG_CONFIG_HOME/sway
mkdir -p $XDG_CONFIG_HOME/waybar
mkdir -p $XDG_CONFIG_HOME/wofi
mkdir -p $XDG_CONFIG_HOME/mako
mkdir -p $XDG_CONFIG_HOME/environment.d
mkdir -p $XDG_CONFIG_HOME/zathura
mkdir -p $XDG_CONFIG_HOME/gtk-3.0
mkdir -p $XDG_CONFIG_HOME/gtk-4.0
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp


printf "\033[1;32m%s\033[0m\n" "[Sway] Linking Configs"
ln -fs $LOC/$COMP/sway-config $XDG_CONFIG_HOME/sway/config
ln -fs $LOC/sway/configs/waybar $XDG_CONFIG_HOME/waybar/config
ln -fs $LOC/sway/configs/waybar.css $XDG_CONFIG_HOME/waybar/style.css
ln -fs $LOC/sway/configs/envvars.conf $XDG_CONFIG_HOME/environment.d/envvars.conf
ln -fs $LOC/sway/configs/wofi $XDG_CONFIG_HOME/wofi/config
ln -fs $LOC/sway/configs/wofi.css $XDG_CONFIG_HOME/wofi/style.css
ln -fs $LOC/sway/configs/mako $XDG_CONFIG_HOME/mako/config
ln -fs $LOC/sway/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc
ln -fs $LOC/sway/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-3.0/settings.ini
ln -fs $LOC/sway/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-4.0/settings.ini
ln -fs $LOC/configs/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml
ln -fs $LOC/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $LOC/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $LOC/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $LOC/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs

printf "\033[1;32m%s\033[0m\n" "[Sway] Setting Default Applications"
xdg-mime default imv-dir.desktop "image/png" "image/jpeg" "image/webp" "image/gif"
xdg-mime default io.mpv.Mpv.desktop "video/mp4" "video/mkv" "video/webm"
xdg-mime default io.mpv.Mpv.desktop "audio/mp3" "audio/m4a" "audio/flac"
xdg-mime default org.gnome.Papers.desktop "application/pdf" "application/vnd.comicbook+zip" "application/vnd.comicbook-rar"

printf "\033[1;32m%s\033[0m\n" "[Sway] Adding Font"
mkdir -p $XDG_DATA_HOME/fonts
wget -nv -O $XDG_DATA_HOME/fonts/material_design_icons.ttf https://github.com/Templarian/MaterialDesign-Webfont/raw/refs/tags/v7.4.47/fonts/materialdesignicons-webfont.ttf


printf "\033[1;32m%s\033[0m\n" "[Sway] Adding tty1 autostart"
echo '# Start Sway at login
if status is-login
        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
                sway
        end
end' > $XDG_CONFIG_HOME/fish/conf.d/sway-autostart.fish
