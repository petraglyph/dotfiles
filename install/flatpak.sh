#!/bin/sh
# Flatpak Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ -z "$(command -v flatpak)" ]; then
	printf "\033[1;31m%s\033[0m\n" "Flatpak not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[Flatpak] Installing packages"
packages="
com.discordapp.Discord
com.github.finefindus.eyedropper
com.google.Chrome
com.mojang.Minecraft
com.valvesoftware.Steam
org.inkscape.Inkscape
us.zoom.Zoom
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
if [ ! -z "$(flatpak remotes | grep fedora)" ]; then
	flatpak -y install fedora $(echo $packages | grep -oE 'org.gnome.[a-zA-Z]*')
	flatpak -y install flathub $(echo $packages | sed 's/org.gnome.[a-zA-Z]*//g')
else
	flatpak -y install flathub $packages
fi
flatpak -y install flathub-beta "org.gimp.GIMP"


printf "\033[1;32m%s\033[0m\n" "[Flatpak] Symlinking ~/.minecraft/"
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
