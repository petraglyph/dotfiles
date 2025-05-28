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
	printf "\033[1;32m%s\033[0m\n" "[Steam] Installing (Flatpak)"
	flatpak install -y flathub "com.valvesoftware.Steam"

	if [ ! -z "$(command -v rpm-ostree)" ]; then
		printf "\033[1;32m%s\033[0m\n" "[Steam] Installing device support (rpm-ostree)"
		rpm-ostree install steam-devices
	elif [ ! -z "$(command -v dnf)" ]; then
		printf "\033[1;32m%s\033[0m\n" "[Steam] Installing device support (DNF)"
		sudo dnf install -y steam-devices
	fi
else
	echo "Unknown OS '$os_id' try:"
	echo "  flatpak install com.valvesoftware.Steam"
	exit 1
fi
