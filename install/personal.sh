#!/bin/sh
# Install and setup personal programs
#   Penn Bauman <me@pennbauman.com>

loc="$(mktemp -d)"

build() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi

	cd $loc
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

rm -rf $loc
