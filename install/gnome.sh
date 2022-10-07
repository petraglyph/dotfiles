#!/bin/sh
# Setup GNOME desktop
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
. "$(dirname $(readlink -f $0))/check.sh" "$comp"


message "GNOME Settings"
# Set theme
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
if [ -d /usr/share/themes/adw-gtk3-dark ]; then
	if [ -z "$(flatpak list | grep adw-gtk3)" ]; then
		flatpak install -y org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
	fi
	gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
else
	error "Missing adw-gtk3-dark"
	echo "  RPM available at https://copr.fedorainfracloud.org/coprs/nickavem/adw-gtk3/ or with:"
	echo
	# Find HTTP RPM download link (for silverblue)
	link=$(curl -s https://copr.fedorainfracloud.org/coprs/nickavem/adw-gtk3/package/adw-gtk3/ | grep -E '<b><a href="/coprs/nickavem/adw-gtk3/build/[0-9]+/">' | tail -n 1)
	. /etc/os-release
	id_str=$(echo $link | sed -e 's/^<b><a href="\/coprs\///' -e 's/\/">$//')
	repo=$(echo $id_str | sed 's/\/build\/[0-9]*//')
	build=$(echo $id_str | sed 's/.*\///')
	package=$(echo $repo | sed 's/.*\///')
	arch="$(uname -i)"
	# Check build numbers with increasing leading '0'
	while [ true ]; do
		#echo "$repo/fedora-$VERSION_ID-$arch/$build-adw-gtk3/"
		url="https://download.copr.fedorainfracloud.org/results/$repo/fedora-$VERSION_ID-$arch/$build-$package/"
		page=$(curl -s $url)
		if [ -z "$(echo $page | grep 404)" ]; then
			pattern="$package-[0-9\.]+-[0-9]+\.fc$VERSION_ID\.$arch\.rpm"
			rpm=$(echo $page | grep -oE "href='$pattern" | sed "s/href='//")
			echo "  curl $url$rpm --output ./$rpm"
			break
		fi
		build=$(echo 0$build)
	done
	echo
	# Print copr install (for mutable fedora)
	echo "  sudo dnf copr enable nickavem/adw-gtk3"
	echo "  dnf install adw-gtk3"
fi

# Set wallpaper
if [ -d $HOME/.dotfiles/$comp ]; then
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.dotfiles/$comp/background.jpg"
	gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.dotfiles/$comp/background.jpg"
fi

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
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KEYBINDING_PATH/custom0/', '$KEYBINDING_PATH/custom1/', '$KEYBINDING_PATH/custom2/', '$KEYBINDING_PATH/custom3/', '$KEYBINDING_PATH/custom4/']"

$KEYBINDING_CMD/custom0/ name "alacritty"
$KEYBINDING_CMD/custom0/ command "alacritty"
$KEYBINDING_CMD/custom0/ binding "<Super>Return"

$KEYBINDING_CMD/custom1/ name "alacritty distrobox"
$KEYBINDING_CMD/custom1/ command "alacritty -e distrobox enter system"
$KEYBINDING_CMD/custom1/ binding "<Super><Shift>Return"

$KEYBINDING_CMD/custom2/ name "alacritty distrobox ranger"
$KEYBINDING_CMD/custom2/ command "alacritty -e distrobox enter system -- ranger --selectfile=$HOME/documents $HOME/documents $HOME/documents"
$KEYBINDING_CMD/custom2/ binding "<Super>f"

$KEYBINDING_CMD/custom2/ name "alacritty distrobox ranger"
$KEYBINDING_CMD/custom2/ command "alacritty -e distrobox enter system -- zellij"
$KEYBINDING_CMD/custom2/ binding "<Super>f"

$KEYBINDING_CMD/custom3/ name "Files"
$KEYBINDING_CMD/custom3/ command "nautilus"
$KEYBINDING_CMD/custom3/ binding "<Super><Shift>f"
