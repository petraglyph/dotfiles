#!/bin/sh
# Elementary OS torrent fetcher
#
# https://elementary.io

if [ $# -eq 0 ]; then
	echo "Missing target directory"
	exit 1
fi
TARGET="$1"
if [ ! -d "$TARGET" ]; then
	if [ -e "$TARGET" ]; then
		echo "'$TARGET' already exists but is not a directory"
		exit 1
	fi
	mkdir -p "$TARGET"
	if [ ! -d "$TARGET" ]; then
		echo "Creating target directory failed"
		exit 1
	fi
fi

MAGNET_REGEX='magnet:\?[-=.:&%a-zA-Z0-9]+'
URL="https://elementary.io"
magnet="$(curl -s "$URL" | grep -oE "$MAGNET_REGEX" | head -n 1)"
filename="$(echo "$magnet" | grep -oE 'dn=[-.a-z0-9]+\.iso' | sed 's/^dn=//').magnet"

if [ ! -e "$TARGET/$filename" ] && [ ! -e "$TARGET/$filename.added" ]; then
	echo "$filename"
	echo "$magnet" > "$TARGET/$filename"
fi
