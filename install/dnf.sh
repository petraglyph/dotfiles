#!/bin/sh
# General DNF Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

if [ -z "$(command -v dnf)" ]; then
	printf "\033[1;31m%s\033[0m\n" "DNF not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[DNF] Updating"
sudo dnf -y upgrade

packages="
bc
curl
dash
fish
gcc
git
htop
lf
neovim
openssh-clients
perl-Image-ExifTool
rsync
util-linux-user
zellij
"
printf "\033[1;32m%s\033[0m\n" "[DNF] Installing Packages"
sudo dnf -y install $packages $@
