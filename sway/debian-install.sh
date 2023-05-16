#!/bin/sh
# Sway Debian Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

packages="
alacritty
bluez
bc
gammastep
sway
swaybg
swayidle
swaylock
waybar
wofi
"
printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Install Packages"
sudo apt -y install $packages
