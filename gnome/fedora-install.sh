#!/bin/sh
# GNOME Fedora Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

packages="
adw-gtk3-theme
alacritty
flatpak
gnome-console
gnome-extensions-app
gnome-shell-extension-appindicator
gnome-shell-extension-caffeine
gnome-tweaks
lf
qalc
toolbox
zathura
zathura-fish-completion
zathura-plugins-all
"

if [ ! -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] OSTree packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
	rpm-ostree install --idempotent $packages
elif [ ! -z "$(command -v dnf)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] Traditional packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[GNOME Fedora] Installing Packages"
	sudo dnf -y install $packages
else
	printf "\033[1;31m%s\033[0m\n" "[GNOME Fedora] Package management not detected"
	exit 1
fi
