#!/bin/sh
# Check config repo locations and computer name
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp="$1"

# Check dotfiles location and comp
if [ -z "$(dirname $(readlink -f $0) | grep "$HOME/.dotfiles")" ]; then
	printf "\033[1;31m%s\033[0m\n" "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if [ -z "$comp" ]; then
	printf "\033[1;31m%s\033[0m\n" "Computer required"
	exit 1
fi

# Check computer is valid or 'none'
if [ "$comp" = "none" ]; then
	exit 0
elif [ -d $loc/$comp ]; then
	if [ $(cat /etc/hostname) != "$comp" ]; then
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
	printf "\033[1;31m%s\033[0m\n" "Unknown computer '$comp'"
	exit 1
fi
