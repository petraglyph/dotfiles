#!/bin/sh
# Setup tower3800x
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
COMP="tower3800x"

# Check install location and computer
$(dirname $(readlink -f $0))/../install/check.sh "$COMP"
if [ $? -ne 0 ]; then
	exit 1
fi

hostnamectl set-hostname $COMP


# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# i3 Fedora Installs
sh ~/.dotfiles/i3/fedora-install.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh io.mpv.Mpv
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $COMP
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $COMP
# Cron Script Installs
sh ~/.dotfiles/install/cron.sh clean-cache dotfiles-backup pcloud-backup
# i3 Configuration
sh ~/.dotfiles/i3/setup.sh $COMP
