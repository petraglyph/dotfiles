#!/bin/sh
# Check config repo locations and computer name
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
LOC="$HOME/.dotfiles"
COMP="$1"

# Check dotfiles location
if [ -z "$(dirname $(realpath "$0") | grep "$HOME/.dotfiles")" ]; then
	printf "\033[1;31m%s\033[0m\n" "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if [ -z "$COMP" ]; then
	exit 0
fi

# Check computer is valid
if [ -d "$LOC/$COMP" ]; then
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
