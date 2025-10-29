#!/bin/sh
# Sway Fedora Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

if [ -z "$(command -v dnf)" ]; then
	printf "\033[1;31m%s\033[0m\n" "DNF not installed"
	exit 1
fi

packages="
alacritty
flatpak
gammastep
grim
sway
swaybg
swayidle
swaylock
toolbox
waybar
zathura
"
printf "\033[1;32m%s\033[0m\n" "[Sway Fedora] Install Packages"
sudo dnf -y install $packages
