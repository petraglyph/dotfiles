#!/bin/sh
# General APT Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[APT] Updating"
sudo apt-get update
sudo apt-get -y upgrade

packages="
apt-file
bc
curl
file
fish
gcc
git
htop
lf
neovim
net-tools
openssh-client
parted
rsync
squashfs-tools-ng
"
printf "\033[1;32m%s\033[0m\n" "[APT] Installing Packages"
sudo apt-get -y install --no-install-recommends $packages $@
