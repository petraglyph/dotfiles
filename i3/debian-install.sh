#!/bin/sh
# i3 Debian Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

packages="
i3-wm
conky
polybar
redshift
rofi
picom
dunst
scrot
feh
"
message "Install Packages"
sudo apt -y install $packages


message "Installing i3lock-color (from source)"
sudo apt-get -y install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
mkdir -p "$HOME/.cache/dotfiles"
cd "$HOME/.cache/dotfiles"
if [ -e i3lock-color ]; then
	cd i3lock-color
	git pull --ff-only
else
	git clone https://github.com/Raymo111/i3lock-color.git
	cd i3lock-color
fi
./install-i3lock-color.sh

if [ -z $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. $HOME/.cargo/env

message "Installing xidlehook (from cargo)"
sudo apt-get -y install libx11-xcb-dev libxcb-screensaver0-dev
cargo install xidlehook --locked --bins

message "Installing alacritty (from cargo)"
sudo apt-get -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cargo install alacritty --locked --bins
