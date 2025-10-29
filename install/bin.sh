#!/bin/sh
# Install script to local bin
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
LOC="$HOME/.dotfiles"
SOURCE="$LOC/bin"
TARGET="$HOME/.local/bin"

# Check install location
$(dirname $(realpath $0))/check.sh
if [ $? -ne 0 ]; then
	exit 1
fi
mkdir -p "$TARGET"

# Remove broken symlinks created by this script
find "$TARGET" -maxdepth 1 -mindepth 1 | while read -r f; do
	if [ -L "$f" ]; then
		if [ -z "$(realpath "$f" | grep "$SOURCE")" ]; then
			continue
		elif [ -e "$(realpath "$f")" ]; then
			continue
		else
			rm "$f"
		fi
	fi
done


printf "\033[1;32m%s\033[0m\n" "[bin] Symlinking to ~/.local/bin"
for f in $SOURCE/*.sh; do
	chmod +x $f
	ln -fs $f "$TARGET/$(basename $f)"
done
