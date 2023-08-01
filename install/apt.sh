#!/bin/sh
# General APT Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[APT] Updating"
sudo apt-get update
sudo apt-get -y upgrade

packages="
bc
curl
fish
gcc
git
htop
lf
neovim
rsync
ssh
"
printf "\033[1;32m%s\033[0m\n" "[APT] Installing Packages"
sudo apt-get -y install --no-install-recommends $packages $@
