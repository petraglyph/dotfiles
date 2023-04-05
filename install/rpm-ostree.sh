#!/bin/sh
# General rpm-ostree Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;31m%s\033[0m\n" "rpm-ostree not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Updating"
rpm-ostree upgrade

packages="
adw-gtk3
alacritty
clang
cronie
dash
distrobox
feh
fish
git-email
htop
lf
lf-fish-integration
lf-zsh-integration
neovim
nethogs
qalc
rclone
ssmtp
util-linux-user
zsh
"
printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
rpm-ostree install --idempotent $packages $@
