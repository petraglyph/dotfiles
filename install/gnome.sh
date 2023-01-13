#!/bin/sh
# Setup GNOME desktop
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
LOC="$HOME/.dotfiles"
COMP=$1

# Check install location and computer
$(dirname $(readlink -f $0))/check.sh "$COMP"
if [ $? -ne 0 ]; then
	exit 1
fi


printf "\033[1;32m%s\033[0m\n" "[GNOME] Configuring"
# Set theme
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
if [ -d /usr/share/themes/adw-gtk3-dark ]; then
	if [ -z "$(flatpak list | grep adw-gtk3)" ]; then
		flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
	fi
	gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
else
	printf "\033[1;31m%s\033[0m\n" "[GNOME] Missing adw-gtk3-dark"
fi

# Set wallpaper
if [ -d $HOME/.dotfiles/$COMP ]; then
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$LOC/$COMP/background.jpg"
	gsettings set org.gnome.desktop.background picture-uri "file://$LOC/$COMP/background.jpg"
fi

# Workspaces
gsettings set org.gnome.mutter workspaces-only-on-primary true
gsettings set org.gnome.mutter dynamic-workspaces false

# Enable nightlight
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage "true"

# Clock display
gsettings set org.gnome.desktop.interface clock-show-date "true"
gsettings set org.gnome.desktop.interface clock-show-seconds "true"
gsettings set org.gnome.desktop.interface clock-show-weekday "true"

# Tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Disable hot corners
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Volume > 100%
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent "true"

# Keyboard
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lalt_lctl', 'caps:escape']"

# Delay screen lock
gsettings set org.gnome.desktop.screensaver lock-delay 120

# Autodelete old trash and temp files
gsettings set org.gnome.desktop.privacy remember-recent-files true
gsettings set org.gnome.desktop.privacy recent-files-max-age 30
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true
gsettings set org.gnome.desktop.privacy old-files-age 30

# Configurate search
gsettings set org.gnome.desktop.search-providers enabled "['org.gnome.Calculator.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Weather.desktop', 'org.gnome.clocks.desktop']"


# Edit keybindings
for i in {1..9}; do
	gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
done
for i in {1..10}; do
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>${i: -1}']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>${i: -1}']"
	#echo "$i ${i: -1}"
done
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>space']"
# Application switching
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Super><Shift>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Super><Shift>Above_Tab']"


# Custom keybindings
KEYBINDING_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEYBINDING_CMD="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KEYBINDING_PATH/custom0/', '$KEYBINDING_PATH/custom1/', '$KEYBINDING_PATH/custom2/', '$KEYBINDING_PATH/custom3/']"

$KEYBINDING_CMD/custom0/ name "alacritty"
$KEYBINDING_CMD/custom0/ command "alacritty"
$KEYBINDING_CMD/custom0/ binding "<Super>Return"

$KEYBINDING_CMD/custom1/ name "alacritty distrobox"
$KEYBINDING_CMD/custom1/ command "alacritty -e distrobox enter"
$KEYBINDING_CMD/custom1/ binding "<Super><Shift>Return"

$KEYBINDING_CMD/custom2/ name "alacritty lf"
$KEYBINDING_CMD/custom2/ command "alacritty -e lf"
$KEYBINDING_CMD/custom2/ binding "<Super>f"

$KEYBINDING_CMD/custom3/ name "Files"
$KEYBINDING_CMD/custom3/ command "nautilus"
$KEYBINDING_CMD/custom3/ binding "<Super><Shift>f"
