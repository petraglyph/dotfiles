#!/bin/sh

# Check dotfiles location and comp
if [[ "$(cd "$(dirname "$BASH_SOURCE")"; pwd)/$(basename "$BASH_SOURCE")" != \
		"$HOME/.dotfiles/install/check.sh" ]]; then
	echo "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if (( $# == 0 )) || [[ $1 == "" ]]; then
	echo "Computer required"
	exit 1
fi

# Check computer is valid or 'none'
if [ -d $loc/$comp ]; then
	if [[ $(hostname) != $comp ]]; then
		echo "Wrong computer, should be $(hostname)"
		while true; do
			read -p "Continue anyway [y/n]: " input
			case $input in
				y|Y) break;;
				n|N) exit 0
					break;;
				*) ;;
			esac
		done
	fi
elif [[ $1 == "none" ]]; then
	continue
else
	echo "Unknown computer '$comp'"
	exit 1
fi
