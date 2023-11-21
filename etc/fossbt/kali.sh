#!/bin/sh
# Kali torrent fetcher
#
# https://www.kali.org/get-kali/#kali-installer-images
# https://cdimage.kali.org/current/

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

BASE_URL="https://cdimage.kali.org/current/"
curl -s "$BASE_URL" | grep -oE 'href=".*\.iso\.torrent"' | sed -e 's/^href="//' -e 's/"$//' | grep -v -e 'i386' -e 'purple' -e 'netinst' | while read -r torrent; do
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s -L "$BASE_URL$torrent" -o "$TARGET/$torrent"
	fi
done
