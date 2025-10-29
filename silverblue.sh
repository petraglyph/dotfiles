#!/bin/sh
# Setup Fedora Silverbue
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
LOC="$HOME/.dotfiles"

# Check install location and computer
$(dirname $(realpath $0))/install/check.sh
if [ $? -ne 0 ]; then
	exit 1
fi


# Fedora Installs
sh $LOC/install/fedora.sh
# GNOME Fedora Installs
sh $LOC/gnome/fedora-install.sh
# Flatpak Installs
sh $LOC/install/flatpak-extra.sh
# Steam Install
sh $LOC/install/steam.sh
# Rust Install
sh $LOC/install/rust.sh
# ~/.local/bin Installs
sh $LOC/install/bin.sh
# Terminal Configuration
sh $LOC/install/terminal.sh
# Systemd User Configuration
sh $LOC/install/systemd-user.sh
# GNOME Configuration
sh $LOC/gnome/setup.sh
