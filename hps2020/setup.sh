#!/bin/sh
# Setup hps2020
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="hps2020"

# Check install location and comp
$(dirname $(readlink -f $0))/../install/check.sh "$comp"
if [ $? -ne 0 ]; then
	exit 1
fi

hostnamectl set-hostname $comp

# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh io.mpv.Mpv
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $comp
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache clean-trash dotfiles-backup
# GNOME Configuration
sh ~/.dotfiles/install/gnome.sh $comp
