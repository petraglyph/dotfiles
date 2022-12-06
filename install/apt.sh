#!/bin/sh
# General APT Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[APT] Updating"
sudo apt-get update
sudo apt-get -y upgrade

packages="
clang
curl
feh
ffmpeg
flatpak
gcc
git-email
htop
mpc
mpd
mpv
ncmpcpp
ncmpcpp
neovim
nethogs
qalc
ranger
rclone
ssmtp
tldr
zsh
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
printf "\033[1;32m%s\033[0m\n" "[APT] Installing Packages"
sudo apt-get -y install $packages
