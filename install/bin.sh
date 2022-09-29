#!/bin/sh
# Install script to local bin
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"

# Check install location and comp
. "$(dirname $(readlink -f $0))/check.sh" "none"

for file in $loc/bin/*; do
	chmod +x $file
	ln -fs $file $HOME/.local/bin/$(basename $file)
done
