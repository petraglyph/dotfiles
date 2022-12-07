#!/bin/sh
# Install script to local bin
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"

# Check install location and comp
$(dirname $(readlink -f $0))/check.sh "none"
if [ $? -ne 0 ]; then
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[bin] Symlinking to ~/.local/bin"
mkdir -p $HOME/.local/bin
for file in $loc/bin/*; do
	chmod +x $file
	ln -fs $file $HOME/.local/bin/$(basename $file)
done
