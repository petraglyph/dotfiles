#!/bin/sh
# i3 Fedora Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"

message "Enabling copr Repositories"
copr() {
	result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
	if [[ $result != "Bugzilla. In case of problems, contact the owner of this repository." ]]; then
		echo $result
	fi
}
copr opuk/pamixer
copr yaroslav/i3desktop
copr pschyska/alacritty
#copr skidnik/termite

packages="
alacritty
conky
dmenu
dunst
i3-gaps
i3status
lxappearance
picom
polybar
rofi
scrot
stalonetray
redshift
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken


message "Builds From Source"
mkdir -p "$loc/.local"

message "  xidlehook"
sudo dnf -y install cargo libX11-devel
cargo install xidlehook

message "  i3lock-color"
cd "$loc/.local"
sudo dnf -y install autoconf automake libev-devel cairo-devel pam-devel \
	xcb-util-image-devel xcb-util-devel xcb-util-xrm-devel \
	libxkbcommon-devel libxkbcommon-x11-devel libjpeg-turbo-devel
if [ ! -d $loc/.local/i3lock-color ]; then
	git clone https://github.com/Raymo111/i3lock-color.git
fi
cd i3lock-color
git pull
git tag -f "git-$(git rev-parse --short HEAD)"
chmod +x build.sh
./build.sh
chmod +x install-i3lock-color.sh
sudo ./install-i3lock-color.sh

