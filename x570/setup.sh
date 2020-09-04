#!/bin/bash
# SETUP x570 Desktop
#   Fedora
#   i3

comp="x570"

if [[ "$(cd "$(dirname "$BASH_SOURCE")"; pwd)/$(basename "$BASH_SOURCE")" != \
	"$HOME/.dotfiles/$comp/setup.sh" ]]; then
	echo "Inproper Loc"
	exit 1
fi

# Fedora Installs
bash ~/.dotfiles/install/fedora.sh $comp
# i3 Fedora Installs
bash ~/.dotfiles/i3/fedora-install.sh $comp
# General Configuration
bash ~/.dotfiles/install/configure.sh $comp
# i3 Configuration
bash ~/.dotfiles/i3/configure.sh $comp
