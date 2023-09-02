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
com.github.tchx84.Flatseal
com.google.Chrome
com.mojang.Minecraft
com.rafaelmardojai.Blanket
io.mpv.Mpv
org.inkscape.Inkscape
org.libreoffice.LibreOffice
org.mozilla.Thunderbird
us.zoom.Zoom
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak -y install flathub $packages
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
