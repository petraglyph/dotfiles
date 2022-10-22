#!/bin/sh
# Fedora Silverblue Install Layered Packages
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

message "Updating"
rpm-ostree upgrade

packages="
alacritty
clang
cronie
dash
distrobox
feh
htop
lsyncd
neovim
nethogs
openssl
postfix
qalc
ranger
rclone
zsh
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
message "Installing Packages"
rpm-ostree install --idempotent $packages
