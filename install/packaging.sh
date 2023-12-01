#!/bin/sh
# Install Packaging Tools
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

os_id="$(grep '^ID=' /etc/os-release | cut -d'=' -f 2)"


if [ "$os_id" = "fedora" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Packaging] Installing (DNF)"
	packages="fedora-packager fedrq podman
	cargo-rpm-macros rust2rpm rust2rpm-helper
	go-rpm-macros go2rpm"
	sudo dnf -y --setopt=install_weak_deps=False install $packages
elif [ "$os_id" = "debian" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Packaging] Installing (APT)"
	packages="devscripts debhelper"
	sudo apt-get -y --no-install---no-install-recommends install $packages
else
	echo "Unknown OS '$os_id'"
	exit 1
fi
