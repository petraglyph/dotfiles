#!/bin/sh
# Setup hps2020
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
COMP="hps2020"

# Check install location and computer
$(dirname $(readlink -f $0))/../install/check.sh "$COMP"
if [ $? -ne 0 ]; then
	exit 1
fi

hostnamectl set-hostname $COMP


# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# GNOME Fedora Installs
sh ~/.dotfiles/gnome/fedora-install.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh com.valvesoftware.Steam
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache clean-trash dotfiles-backup
# GNOME Configuration
sh ~/.dotfiles/gnome/setup.sh $COMP
