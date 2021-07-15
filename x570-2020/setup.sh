#!/bin/bash
# Setup x570 Desktop
#   Fedora
#   i3

loc="$HOME/.dotfiles"
comp="x570-2020"

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
bash ~/.dotfiles/i3/configure.sh $comp
# Install Personal Programs
bash ~/.dotfiles/install/personal.sh
