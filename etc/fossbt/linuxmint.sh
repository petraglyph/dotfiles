#!/bin/sh
# Linux Mint torrent fetcher
#
# https://www.linuxmint.com/download.php
# https://www.linuxmint.com/torrents/

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

# Standard Linux Mint
version="$(curl -s "https://linuxmint.com/download.php" | grep -oE "<title>Download Linux Mint [0-9]+\.[0-9]+ - Linux Mint</title>" | grep -oE '[0-9]+\.[0-9]+')"
BASE_URL="https://linuxmint.com/torrents"
for desktop in cinnamon xfce; do
	torrent="linuxmint-$version-$desktop-64bit.iso.torrent"
	
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$BASE_URL/$torrent" -o "$TARGET/$torrent"
	fi
done

# Linux Mint Debian Edition
version_lmde="$(curl -s "https://linuxmint.com/download_lmde.php" | grep -oE "<title>Download LMDE [0-9]+ - Linux Mint</title>" | grep -oE '[0-9]+')"
torrent_lmde="lmde-$version_lmde-cinnamon-64bit.iso.torrent"
if [ ! -e "$TARGET/$torrent_lmde" ] && [ ! -e "$TARGET/$torrent_lmde.added" ]; then
	echo "$torrent_lmde"
	curl -s "$BASE_URL/$torrent_lmde" -o "$TARGET/$torrent_lmde"
fi
