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
# Flatpak Installs
sh ~/.dotfiles/install/flatpak.sh org.gnome.Geary io.mpv.Mpv
# Rust Install
sh ~/.dotfiles/install/rust.sh
# ~/.local/bin Installs
sh ~/.dotfiles/install/bin.sh
# Terminal Configuration
sh ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
sh ~/.dotfiles/install/desktop.sh $comp
# GNOME Configuration
sh ~/.dotfiles/install/gnome.sh $comp
