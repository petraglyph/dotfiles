#!/bin/sh
# Install and setup personal programs

loc="$HOME/.dotfiles"

# Check install location
source "$(dirname $BASH_SOURCE)/check.sh" "none"

# Adding local directory
mkdir -p $loc/.local

build() {
	message "$1"
	cd "$loc/.local"
	if [ -e $1 ]; then
		cd $1
		git pull
	else
		git clone https://github.com/pennbauman/$1.git
		cd $1
	fi
	./install.sh
}


build "pmi"
pmi disable --yes
if [ $(command -v rpm) ]; then
	pmi enable dnf
	pmi enable flatpak
elif [ $(command -v apt) ]; then
	pmi enable apt
elif [ $(command -v yay) ]; then
	pmi enable yay
fi


build "bool-test"

build "dndice"

build "ibcmer"

