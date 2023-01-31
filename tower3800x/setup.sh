#!/bin/sh
# Setup tower3800x
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="tower3800x"

# Check install location and comp
$(dirname $(readlink -f $0))/../install/check.sh "$comp"
if [ $? -ne 0 ]; then
	exit 1
fi

hostnamectl set-hostname $comp

# Ubuntu Installs
sh ~/.dotfiles/install/ubuntu.sh
# i3 Ubuntu Installs
sh ~/.dotfiles/i3/ubuntu-install.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh org.mozilla.firefox
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $comp
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache dotfiles-backup pcloud-backup
# i3 Configuration
sh ~/.dotfiles/i3/setup.sh $comp
