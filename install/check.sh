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
	continue
elif [[ $1 == "none" ]]; then
	continue
else
	echo "Unknown computer '$comp'"
	exit 1
fi
