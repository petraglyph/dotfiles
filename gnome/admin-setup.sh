#!/bin/sh
# Configure GNOME for admin user
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles


printf "\033[1;32m%s\033[0m\n" "[GNOME] Configuring"
# Set theme
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

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

# Disable screen lock
gsettings set org.gnome.desktop.screensaver lock-enabled false


printf "\033[1;32m%s\033[0m\n" "[GNOME] Setting Keybindings"
# Edit keybindings
gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>space']"
# Application switching
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super><Shift>Tab']"
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

# Custom keybindings
KEYBINDING_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEYBINDING_CMD="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEYBINDING_PATH"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KEYBINDING_PATH/custom0/', '$KEYBINDING_PATH/custom1/']"

$KEYBINDING_CMD/custom0/ name "Files"
$KEYBINDING_CMD/custom0/ command "nautilus"
$KEYBINDING_CMD/custom0/ binding "<Super><Shift>f"

if command -v kgx &> /dev/null; then
	$KEYBINDING_CMD/custom1/ name "Gnome Console"
	$KEYBINDING_CMD/custom1/ command "kgx"
	$KEYBINDING_CMD/custom1/ binding "<Super>Return"
elif command -v ptyxis &> /dev/null; then
	$KEYBINDING_CMD/custom1/ name "Ptyxis Terminal"
	$KEYBINDING_CMD/custom1/ command "ptyxis --new-window"
	$KEYBINDING_CMD/custom1/ binding "<Super>Return"
elif command -v gnome-terminal &> /dev/null; then
	$KEYBINDING_CMD/custom1/ name "Gnome Terminal"
	$KEYBINDING_CMD/custom1/ command "gnome-terminal"
	$KEYBINDING_CMD/custom1/ binding "<Super>Return"
else
	printf "\033[1;33m%s\033[0m\n" "[GNOME] No terminal found"
fi
