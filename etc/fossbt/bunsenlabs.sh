#!/bin/sh
# BunsenLabs torrent fetcher
#
# https://www.bunsenlabs.org/installation.html
# https://ddl.bunsenlabs.org/ddl/

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

BASE_URL="https://ddl.bunsenlabs.org/ddl"
SUMMARY_URL="$BASE_URL/release.sha256.txt"
curl -s "$SUMMARY_URL" | grep 'amd64' | while read -r l; do
	iso="$(echo "$l" | sed 's/^.* //')"
	torrent="$iso.torrent"

	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$BASE_URL/$torrent" -o "$TARGET/$torrent"
	fi
done
