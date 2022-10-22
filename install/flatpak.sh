#!/bin/sh
# Flatpak Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

# Check flatpak installed
if [ -z $(command -v "flatpak") ]; then
	question="Flatpak not found, install? [y/n]"
	while true; do
		read -p "$question" c
		case $c in
			y|Y|yes) break ;;
			n|N|no) exit 0 ;;
			*) echo "  Invalid input, please use 'y' or 'n'" ;;
		esac
		question="Install? [y/n] "
	done
	if [ ! -z $(command -v "dnf") ]; then
		sudo dnf -y install flatpak
	elif [ ! -z $(command -v "apt-get") ]; then
		sudo apt-get -y install flatpak
	else
		echo "Unknown package manager, could not install flatpak"
		exit 1
	fi
fi


message "Installing Flatpaks"
packages="
com.discordapp.Discord
com.github.finefindus.eyedropper
com.google.Chrome
com.mojang.Minecraft
com.valvesoftware.Steam
org.inkscape.Inkscape
us.zoom.Zoom
io.mpv.Mpv
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
if [ ! -z "$(flatpak remotes | grep fedora)" ]; then
	flatpak -y install fedora $(echo $packages | grep -oE 'org.gnome.[a-zA-Z]*')
	flatpak -y install flathub $(echo $packages | sed 's/org.gnome.[a-zA-Z]*//g')
else
	flatpak -y install flathub $packages
fi
flatpak -y install flathub-beta "org.gimp.GIMP"


message "Symlinking ~/.minecraft/"
MC_DIR="$HOME/.var/app/com.mojang.Minecraft/.minecraft"
mkdir -p $MC_DIR/saves
mkdir -p $MC_DIR/resourcepacks
if [ -d $HOME/.minecraft ]; then
	if [ ! -L $HOME/.minecraft ]; then
		echo "~/.minecraft/ already exists"
	elif [ "$(realpath $HOME/.minecraft)" != "$MC_DIR" ]; then
		echo "~/.minecraft/ is an unknown symlink"
		echo "$(realpath $HOME/.minecraft) != $MC_DIR"
	fi
else
	ln -fs $MC_DIR $HOME/.minecraft
fi
