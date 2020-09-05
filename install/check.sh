#!/bin/sh
# Check dotfiles location

if [[ "$(cd "$(dirname "$BASH_SOURCE")"; pwd)/$(basename "$BASH_SOURCE")" != \
		"$HOME/.xotfiles/install/check.sh" ]]; then
	echo "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

