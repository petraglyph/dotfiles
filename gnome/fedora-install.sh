#!/bin/sh
# General Fedora Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

packages="
adw-gtk3
alacritty
gnome-console
gnome-tweaks
lf
qalc
"

if [ ! -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] OSTree packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[GNOME Fedora] Enabling Copr repositories"
	curl -s "https://copr.fedorainfracloud.org/coprs/nickavem/adw-gtk3/repo/fedora-/" | sudo tee /etc/yum.repos.d/nickavem-adw-gtk3.repo > /dev/null

	printf "\033[1;32m%s\033[0m\n" "[rpm-ostree] Installing Packages"
	rpm-ostree install --idempotent $packages
elif [ ! -z "$(command -v dnf)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[GNOME Fedora] Traditional packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[GNOME Fedora] Enabling Copr repositories"
	copr() {
		result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
		if [ "$result" != "Bugzilla. In case of problems, contact the owner of this repository." ]; then
			echo $result
		fi
	}
	copr nickavem/adw-gtk3

	printf "\033[1;32m%s\033[0m\n" "[GNOME Fedora] Installing Packages"
	sudo dnf -y install $packages --skip-broken
else
	printf "\033[1;31m%s\033[0m\n" "[GNOME Fedora] Package management not detected"
	exit 1
fi
