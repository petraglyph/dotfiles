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
com.github.finefindus.eyedropper
com.github.neithern.g4music
com.github.tchx84.Flatseal
com.google.Chrome
com.rafaelmardojai.Blanket
io.mpv.Mpv
org.gimp.GIMP
org.gnome.Papers
org.libreoffice.LibreOffice
"
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --system flathub $packages $@
