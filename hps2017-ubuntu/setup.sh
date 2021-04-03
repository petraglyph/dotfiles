#!/bin/bash
# Setup hps2017
#   Ubuntu
#   i3

loc="$HOME/.dotfiles"
comp="hps2017-ubuntu"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

# Ubuntu Installs
bash ~/.dotfiles/install/ubuntu.sh
# i3 Fedora Installs
bash ~/.dotfiles/i3/ubuntu-install.sh
# Terminal Configuration
bash ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
bash ~/.dotfiles/install/desktop.sh $comp
# i3 Configuration
bash ~/.dotfiles/i3/configure.sh $comp
# Install Personal Programs
bash ~/.dotfiles/install/personal.sh
