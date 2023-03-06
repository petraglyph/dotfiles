#!/bin/sh
# FreeBSD torrent fetcher
#
# https://wiki.freebsd.org/Torrents

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

MAGNET_REGEX='magnet:\?[-=.:;&%a-zA-Z0-9]+'
URL="https://wiki.freebsd.org/Torrents"
all_magnets="$(curl -s "$URL" | grep -oE "$MAGNET_REGEX" | grep xz)"

# x86_64
echo "$all_magnets" | grep amd64 | grep -e memstick -e bootonly | while read -r magnet; do
	filename="$(echo "$magnet" | grep -oE 'dn=[-.a-zA-Z0-9]+' | sed 's/^dn=//').magnet"

	if [ ! -e "$TARGET/$filename" ] && [ ! -e "$TARGET/$filename.added" ]; then
		echo "$filename"
		echo "$magnet" > "$TARGET/$filename"
	fi
done

# aarch64
echo "$all_magnets" | grep arm64 | grep -e bootonly -e mini -e RPI | while read -r magnet; do
	filename="$(echo "$magnet" | grep -oE 'dn=[-.a-zA-Z0-9]+' | sed 's/^dn=//').magnet"

	if [ ! -e "$TARGET/$filename" ] && [ ! -e "$TARGET/$filename.added" ]; then
		echo "$filename"
		echo "$magnet" > "$TARGET/$filename"
	fi
done
