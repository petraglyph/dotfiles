#!/bin/sh
# General pacman Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ -z "$(command -v pacman)" ]; then
	printf "\033[1;31m%s\033[0m\n" "pacman not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[pacman] Updating"
sudo pacman -Syu --noconfirm

packages="
bc
curl
file
fish
gcc
git
htop
lf
neovim
openssh
parted
rsync
"
printf "\033[1;32m%s\033[0m\n" "[APT] Installing Packages"
sudo pacman -S --noconfirm $packages $@
