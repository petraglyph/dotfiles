#!/bin/sh
# General Fedora Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

packages="
adw-gtk3-theme
alacritty
gnome-console
gnome-tweaks
lf
qalc
"

if [ ! -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] OSTree packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
	rpm-ostree install --idempotent $packages
elif [ ! -z "$(command -v dnf)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] Traditional packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[GNOME Fedora] Installing Packages"
	sudo dnf -y install $packages --skip-broken
else
	printf "\033[1;31m%s\033[0m\n" "[GNOME Fedora] Package management not detected"
	exit 1
fi
