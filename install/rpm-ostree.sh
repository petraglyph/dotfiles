#!/bin/sh
# General rpm-ostree Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

if [ -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;31m%s\033[0m\n" "rpm-ostree not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Updating"
rpm-ostree upgrade

packages="
btrbk
dash
duperemove
fish
htop
lf
neovim
nethogs
openssl
perl-Image-ExifTool
playerctl
python3-devel
qalc
rclone
squashfs-tools-ng
ssmtp
transmission-cli
zellij
zstd
"
printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
rpm-ostree install --idempotent $packages $@
