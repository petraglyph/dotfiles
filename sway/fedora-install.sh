#!/bin/sh
# Sway Fedora Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v dnf)" ]; then
	printf "\033[1;31m%s\033[0m\n" "DNF not installed"
	exit 1
fi

packages="
alacritty
gammastep
sway
swaybg
swayidle
swaylock
waybar
"
printf "\033[1;32m%s\033[0m\n" "[Sway Fedora] Install Packages"
sudo dnf -y install $packages --skip-broken
