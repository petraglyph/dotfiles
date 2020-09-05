#!/bin/bash
# Setup hps2020
#   Fedora
#   i3

# Check install location
source "$(dirname $BASH_SOURCE)/../install/check.sh"

loc="$HOME/.dotfiles"
comp="hps2020"

# Fedora Installs
bash ~/.dotfiles/install/fedora.sh
# i3 Fedora Installs
bash ~/.dotfiles/i3/fedora-install.sh
# General Configuration
bash ~/.dotfiles/install/configure.sh $comp
# i3 Configuration
bash ~/.dotfiles/i3/configure.sh $comp
