#!/bin/sh
# General Debian Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

message "Updating"
sudo apt-get update
sudo apt-get -y upgrade

if [ ! -z "$(grep 'ID=ubuntu' /etc/os-release)" ]; then
	message "Adding Neovim Stable PPA"
	sudo add-apt-repository -y ppa:neovim-ppa/stable
fi

packages="
clang
curl
feh
ffmpeg
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
message "Installing Packages"
sudo apt-get -y install $packages
