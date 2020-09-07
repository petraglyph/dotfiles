#!/bin/sh

message() {
	echo -e "\033[1;32m$1\033[0m"
}
error() {
	echo -e "\033[31m$1\033[0m"
}

# Check dotfiles location and comp
if [[ "$(cd "$(dirname "$BASH_SOURCE")"; pwd)/$(basename "$BASH_SOURCE")" != \
		"$HOME/.dotfiles/install/check.sh" ]]; then
	error "Move repository to ~/.dotfiles before configuring"
	exit 1
fi

# Check computer is provided
if (( $# == 0 )) || [[ $1 == "" ]]; then
	error "Computer required"
	exit 1
fi

# Check computer is valid or 'none'
if [ -d $loc/$comp ]; then
	if [[ $(hostname) != $comp ]]; then
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
elif [[ $1 == "none" ]]; then
	continue
else
	error "Unknown computer '$comp'"
	exit 1
fi
