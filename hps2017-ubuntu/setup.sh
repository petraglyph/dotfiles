#!/bin/bash
# SETUP ubuntu on hps2017
#   Fedora
#   i3

comp="hops2017-ubuntu"

if [[ "$(cd "$(dirname "$BASH_SOURCE")"; pwd)/$(basename "$BASH_SOURCE")" != \
	"$HOME/.dotfiles/$comp/setup.sh" ]]; then
	echo "Inproper Loc"
	exit 1
fi

# Ubuntu Installs
bash ~/.dotfiles/install/ubuntu.sh $comp
# General Configuration
bash ~/.dotfiles/install/configure.sh $comp
