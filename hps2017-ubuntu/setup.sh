#!/bin/bash
# Setup hps2017
#   Ubuntu

loc="$HOME/.dotfiles"
comp="hps2017-ubuntu"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

# Ubuntu Installs
bash ~/.dotfiles/install/ubuntu.sh
# Terminal Configuration
bash ~/.dotfiles/install/terminal.sh $comp
# Desktop Configuration
bash ~/.dotfiles/install/desktop.sh $comp
# Install Personal Programs
bash ~/.dotfiles/install/personal.sh
