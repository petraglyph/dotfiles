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

BASE_URL="https://www.linuxmint.com/torrents/"
torrents_all="$(curl -s "$BASE_URL" | grep -oE 'href=".*\.torrent"' | sed -e 's/^href="//' -e 's/"$//')"
torrents_mint="$(echo "$torrents_all" | grep -oE "^linuxmint.*64bit\.iso\.torrent$" | sort)"
for desktop in cinnamon xfce; do
	torrent="$(echo "$torrents_mint" | grep "$desktop" | tail -n 1)"
	
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$BASE_URL$torrent" -o "$TARGET/$torrent"
	fi
done

torrent_lmde="$(echo "$torrents_all" | grep -oE "^lmde.*64bit\.iso\.torrent$" | sort | tail -n 1)"
if [ ! -e "$TARGET/$torrent_lmde" ] && [ ! -e "$TARGET/$torrent_lmde.added" ]; then
	echo "$torrent_lmde"
	curl -s "$BASE_URL$torrent_lmde" -o "$TARGET/$torrent_lmde"
fi
