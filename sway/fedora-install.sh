#!/bin/sh
# Sway Fedora Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

packages="
alacritty
gammastep
sway
swaybg
swayidle
swaylock
waybar
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken
