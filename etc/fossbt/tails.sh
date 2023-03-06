#!/bin/sh
# Tails torrent fetcher
#
# https://tails.boum.org/install/download/index.en.html
# https://tails.boum.org/torrents/files/

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

BASE_URL="https://tails.boum.org/torrents/files/"
curl -s "$BASE_URL" | grep -oE 'href="[-.a-z0-9]+iso\.torrent"' | sed -e 's/^href="//' -e 's/"$//' | while read -r torrent; do
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$BASE_URL$torrent" -o "$TARGET/$torrent"
	fi
done
