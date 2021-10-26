#!/bin/bash
# i3 Fedora Installs
#   Penn Bauman <me@pennbauman.com>

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
copr sentry/i3desktop
#copr opuk/pamixer


packages="
alacritty
conky
dmenu
dunst
feh
i3-gaps
i3lock-color
i3status
lxappearance
picom
polybar
redshift
rofi
stalonetray
xset
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken


message "Builds From Source"
mkdir -p "$loc/.local"

message "  xidlehook"
sudo dnf -y install libX11-devel
if [ -z $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
source $HOME/.cargo/env
cargo install xidlehook --locked --bins

message "  pamixer"
sudo dnf -y install boost-devel pulseaudio-libs-devel
cd "$loc/.local"
if [ -e pamixer ]; then
	cd pamixer
	git pull
else
	git clone https://github.com/cdemoulins/pamixer.git
	cd pamixer
fi
make && sudo cp pamixer /bin

message "  scrot"

cd "$loc/.local"
sudo dnf -y install autoconf-archive imlib2-devel libtool libXcomposite-devel libXfixes-devel
if [ -e scrot ]; then
	cd scrot
	git pull
else
	git clone https://github.com/resurrecting-open-source-projects/scrot.git
	cd scrot
fi
./autogen.sh
./configure
make
sudo make install
