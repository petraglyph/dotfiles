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
fish
git-email
htop
lf
neovim
nethogs
openssl
perl-Image-ExifTool
python3-devel
qalc
rclone
squashfs-tools-ng
ssmtp
transmission-cli
zellij
"
printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
rpm-ostree install --idempotent $packages $@
