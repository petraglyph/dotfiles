#!/bin/bash
# Setup hps2020
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="hps2020"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

# Fedora Installs
bash ~/.dotfiles/install/fedora.sh
# i3 Fedora Installs
bash ~/.dotfiles/i3/fedora-install.sh
# Terminal Configuration
bash ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
bash ~/.dotfiles/install/desktop.sh $comp
# i3 Configuration
bash ~/.dotfiles/i3/setup.sh $comp
# Install Personal Programs
bash ~/.dotfiles/install/personal.sh
