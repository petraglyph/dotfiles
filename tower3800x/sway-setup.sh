#!/bin/sh
# Setup tower3800x with Sway
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
COMP="tower3800x"

# Check install location and computer
$(dirname $(realpath $0))/../install/check.sh $COMP
if [ $? -ne 0 ]; then
	exit 1
fi

if [ $(hostname) != $COMP ]; then
	hostnamectl set-hostname $COMP
fi


# Debian Installs
sh ~/.dotfiles/install/debian.sh
# Sway Debian Installs
sh ~/.dotfiles/sway/debian-install.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh org.mozilla.firefox
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Steam Install
sh ~/.dotfiles/install/steam.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache dotfiles-backup pcloud-backup
# Sway Configuration
sh ~/.dotfiles/sway/setup.sh $COMP
