#!/bin/sh
# Setup x570 Desktop
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="x570-2020"

# Check install location and comp
. "$(dirname $(readlink -f $0))/../install/check.sh" "$comp"

# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh
# Sway Fedora Installs
sh ~/.dotfiles/sway/fedora-install.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $comp
# i3 Configuration
sh ~/.dotfiles/sway/setup.sh $comp
