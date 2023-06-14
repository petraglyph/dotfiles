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
clang
cronie
dash
dnf
dnf5
feh
fish
git-email
htop
lf
lf-fish-integration
neovim
nethogs
openssl
perl-Image-ExifTool
python3-pip
qalc
rclone
ssmtp
transmission-cli
util-linux-user
zellij
"
printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
rpm-ostree install --idempotent $packages $@
