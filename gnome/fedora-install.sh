#!/bin/sh
# GNOME Fedora Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

packages="
alacritty
gnome-extensions-app
gnome-shell-extension-appindicator
gnome-shell-extension-caffeine
gnome-shell-extension-system-monitor
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

	printf "\033[1;32m%s\033[0m\n" "[DNF] Installing Packages"
	sudo dnf -y install $packages flatpak toolbox
else
	printf "\033[1;31m%s\033[0m\n" "[GNOME Fedora] Package management not detected"
	exit 1
fi
