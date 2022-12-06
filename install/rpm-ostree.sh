#!/bin/sh
# General rpm-ostree Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;31m%s\033[0m\n" "rpm-ostree not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Updating"
rpm-ostree upgrade

packages="
alacritty
clang
cronie
dash
distrobox
feh
git-email
htop
neovim
nethogs
qalc
rclone
ssmtp
util-linux-user
zsh
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
rpm-ostree install --idempotent $packages
