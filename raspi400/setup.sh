#!/bin/sh
# Setup raspi400 with Sway
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
COMP="raspi400"

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
sh ~/.dotfiles/sway/debian-install.sh chromium
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache
# Sway Configuration
sh ~/.dotfiles/sway/setup.sh $COMP
