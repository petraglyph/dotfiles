#!/bin/bash
# Setup Server
#   Fedora

loc="$HOME/.dotfiles"
comp="server"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "$comp"

# Fedora Server Installs
bash ~/.dotfiles/$comp/fedora-install.sh
# Terminal Configuration
bash ~/.dotfiles/install/terminal.sh $comp
