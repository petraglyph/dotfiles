#!/bin/sh
# Setup hps2020
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="hps2020"

# Check install location and comp
. "$(dirname $(readlink -f $0))/../install/check.sh" "$comp"

hostnamectl set-hostname $comp

# Fedora Installs
sh ~/.dotfiles/install/fedora.sh
# i3 Fedora Installs
sh ~/.dotfiles/i3/fedora-install.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $comp
# i3 Configuration
sh ~/.dotfiles/i3/setup.sh $comp
# Install Personal Programs
sh ~/.dotfiles/install/personal.sh
