#!/bin/sh
# Setup tower3800x
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
sh ~/.dotfiles/install/debian.sh extra
# i3 Debian Installs
sh ~/.dotfiles/i3/debian-install.sh
# Firefox install
sh ~/.dotfiles/install/firefox.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh
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
# i3 Configuration
sh ~/.dotfiles/i3/setup.sh $COMP
