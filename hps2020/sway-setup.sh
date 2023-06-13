#!/bin/sh
# Setup hps2020 with Sway
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
COMP="hps2020"

# Check install location and computer
$(dirname $(realpath $0))/../install/check.sh $COMP
if [ $? -ne 0 ]; then
	exit 1
fi

if [ $(hostname) != $COMP ]; then
	hostnamectl set-hostname $COMP
fi


# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh io.mpv.Mpv
# Sway Fedora Installs
sh ~/.dotfiles/sway/fedora-install.sh
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
# Sway Configuration
sh ~/.dotfiles/sway/setup.sh $COMP
