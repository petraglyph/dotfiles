#!/bin/sh
# Check config repo locations and computer name
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
LOC="$HOME/.dotfiles"
COMP="$1"

# Check dotfiles location
if [ -z "$(dirname $(realpath "$0") | grep "$HOME/.dotfiles")" ]; then
	printf "\033[1;31m%s\033[0m\n" "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if [ -z "$COMP" ]; then
	printf "\033[1;31m%s\033[0m\n" "Computer required"
	exit 1
fi

# Check computer is valid or 'none'
if [ "$COMP" = "none" ]; then
	exit 0
elif [ -d "$LOC/$COMP" ]; then
	if [ "$(hostname)" != "$COMP" ] && [ "$(hostname | sed 's/\..*$//')" != "$COMP" ]; then
		printf "\033[1;31m%s\033[0m\n" "Wrong computer, should be '$(hostname)'"
		while true; do
			read -p "  Continue anyway [y/n]: " input
			case $input in
				y|Y) break;;
				n|N) exit 1
					break;;
				*) ;;
			esac
		done
	fi
else
	printf "\033[1;31m%s\033[0m\n" "Unknown computer '$COMP'"
	exit 1
fi
