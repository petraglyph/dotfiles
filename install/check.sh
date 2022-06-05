#!/bin/sh
# Check config repo locations and computer name
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}
error() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;31m$1\033[0m"
	else
		echo -e "\033[1;31m$1\033[0m"
	fi
}

# Check dotfiles location and comp
if [ -z "$(dirname $(readlink -f $0) | grep "$HOME/.dotfiles")" ]; then
	error "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if [ -z "$1" ]; then
	error "Computer required"
	exit 1
fi

# Check computer is valid or 'none'
if [ $1 = "none" ]; then
	sleep 0
elif [ -d $loc/$comp ]; then
	if [ $(hostname) != $comp ]; then
		error "Wrong computer, should be '$(hostname)'"
		while true; do
			read -p "  Continue anyway [y/n]: " input
			case $input in
				y|Y) break;;
				n|N) exit 0
					break;;
				*) ;;
			esac
		done
	fi
else
	error "Unknown computer '$comp'"
	exit 1
fi
