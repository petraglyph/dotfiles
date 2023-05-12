#!/bin/sh
# Install Steam
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

os_id="$(grep '^ID=' /etc/os-release | cut -d'=' -f 2)"

if [ "$os_id" = "debian" ] || [ "$os_id" = "ubuntu" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Steam] Installing (APT)"
	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo apt-get -y install steam-installer
elif [ "$os_id" = "fedora" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Steam] Installing (DNF)"
	if [ -z "$(dnf repolist | grep rpmfusion-nonfree)" ]; then
		printf "\033[1;32m%s\033[0m\n" "[Steam] Enabling RPM Fusion"
		sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	fi
	sudo dnf -y install steam
else
	echo "Unknown OS '$os_id'"
	exit 1
fi
