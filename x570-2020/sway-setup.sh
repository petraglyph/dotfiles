#!/bin/bash
# Setup x570 Desktop
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="x570-2020"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

# Fedora Installs
bash ~/.dotfiles/install/fedora.sh
# Sway Fedora Installs
bash ~/.dotfiles/sway/fedora-install.sh
# Terminal Configuration
bash ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
bash ~/.dotfiles/install/desktop.sh $comp
# i3 Configuration
bash ~/.dotfiles/sway/configure.sh $comp
# Folding@Home Configuration
bash ~/.dotfiles/install/fah.sh
# Install Personal Programs
bash ~/.dotfiles/install/personal.sh
