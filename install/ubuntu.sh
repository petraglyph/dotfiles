#!/bin/sh
# General Ubuntu Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

sudo apt-get update
sudo apt-get -y upgrade

packages="
curl
feh
gcc
git
mpd
ncmpcpp
nodejs
npm
qalc
zsh
"
message "Installing Packages"
sudo apt-get -y install $packages


message "Installing Rust (with rustup)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
