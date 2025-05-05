#!/bin/sh
# Configure GNOME
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LOC="$HOME/.dotfiles"
BG_FILE="$LOC/gnome/background.jpg"

# Check install location and computer
$(dirname $(realpath $0))/../install/check.sh
if [ $? -ne 0 ]; then
	exit 1
fi


printf "\033[1;32m%s\033[0m\n" "[GNOME] Linking Configs"
mkdir -p $XDG_CONFIG_HOME/alacritty
ln -fs $LOC/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs
ln -fs $LOC/configs/alacritty.toml $XDG_CONFIG_HOME/alacritty/alacritty.toml

mkdir -p $XDG_CONFIG_HOME/autostart
for f in $LOC/gnome/autostart/*; do
	ln -fs $f $XDG_CONFIG_HOME/autostart/$(basename $f)
done


printf "\033[1;32m%s\033[0m\n" "[GNOME] Configuring"
# Set theme
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface accent-color 'green'

# Set wallpaper
gsettings set org.gnome.desktop.background picture-uri-dark "file://$BG_FILE"
gsettings set org.gnome.desktop.background picture-uri "file://$BG_FILE"

# Workspaces
gsettings set org.gnome.mutter workspaces-only-on-primary true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10

# Enable nightlight
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Clock display
gsettings set org.gnome.desktop.interface clock-format "24h"
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true

# Tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Disable hot corners
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Volume > 100%
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true

# Keyboard
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lalt_lctl', 'caps:escape', 'altwin:menu_win']"

# Delay screen lock
gsettings set org.gnome.desktop.screensaver lock-delay 120

# Autodelete old trash and temp files
gsettings set org.gnome.desktop.privacy remember-recent-files true
gsettings set org.gnome.desktop.privacy recent-files-max-age 30
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy old-files-age 30

# Configurate search
gsettings set org.gnome.desktop.search-providers enabled "['org.gnome.Calculator.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.clocks.desktop']"
gsettings set org.gnome.desktop.search-providers sort-order "['org.gnome.Calculator.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.clocks.desktop']"
gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Software.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calendar.desktop']"

# Set default apps
xdg-mime default org.gnome.Papers.desktop application/pdf
xdg-mime default org.gnome.Loupe.desktop image/png image/jpeg image/webp
xdg-mime default io.mpv.Mpv.desktop video/mp4 video/mkv video/webm
xdg-mime default org.gnome.Decibels.desktop audio/mp3 audio/m4a audio/flac


# Extensions
printf "\033[1;32m%s\033[0m\n" "[GNOME] Enabling Extensions"
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable caffeine@patapon.info
gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable system-monitor@gnome-shell-extensions.gcampax.github.com


printf "\033[1;32m%s\033[0m\n" "[GNOME] Setting Keybindings"
# Edit keybindings
gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys help "[]"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>space']"
# Application switching
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super><Shift>Tab']"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "[]"
i=1
while [ $i -le 10 ]; do
	if [ $i -le 9 ]; then
		gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
	fi
	j=$(($i % 10))
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$j']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$j']"
	i=$(($i + 1))
done


if [ -z "$(command -v alacritty)" ]; then
	printf "\033[1;33m%s\033[0m\n" "[GNOME] Missing alacritty"
	exit 1
fi
# Custom keybindings
KEYBINDING_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEYBINDING_CMD="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH"
array="["
for i in $(seq 0 10); do
	array="$array'$KEYBINDING_PATH/custom$i/', "
done
array="$(echo "$array" | sed -E 's/, $//')]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$array"

keybind () {
	$KEYBINDING_CMD/custom$1/ name "$2"
	$KEYBINDING_CMD/custom$1/ command "$3"
	$KEYBINDING_CMD/custom$1/ binding "$4"
}

# Media
keybind 0 "Media Play/Pause" "playerctl play-pause" "<Super>Pause"
keybind 1 "Media Next" "playerctl next" "<Super><Shift>Right"
keybind 2 "Media Previous" "playerctl previous" "<Super><Shift>Left"
keybind 3 "Volume Up" "pactl set-sink-volume @DEFAULT_SINK@ +5%" "<Super><Shift>Up"
keybind 4 "Volume Up" "pactl set-sink-volume @DEFAULT_SINK@ -5%" "<Super><Shift>Down"
keybind 5 "Mute Toggle" "pactl set-sink-mute @DEFAULT_SINK@ toggle" "<Super>Delete"

# Programs
keybind 6 "Files" "nautilus" "<Super><Shift>f"
keybind 7 "alacritty" "alacritty" "<Super>Return"
keybind 8 "alacritty lf" "alacritty -e lf" "<Super>f"
keybind 9 "alacritty toolbox" "alacritty -e toolbox enter" "<Super><Shift>Return"
keybind 10 "alacritty qalc" "alacritty -e qalc" "<Super>c"
