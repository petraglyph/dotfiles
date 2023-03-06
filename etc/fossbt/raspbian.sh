#!/bin/sh
# Raspberry Pi torrent fetcher
#
# https://www.raspberrypi.com/software/operating-systems/

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

for arch in armhf arm64; do
	for os in raspios raspios_lite raspios_full; do
		base_url="https://downloads.raspberrypi.org/${os}_${arch}/images/"
		release="$(curl -s "$base_url" | grep -oE 'href="[-_A-Za-z0-9\/]+"' | tail -n 1 | sed -e 's/^href="//' -e 's/"$//')"
		torrent="$(curl -s "$base_url$release" | grep -oE 'href="[-_.A-Za-z0-9]+\.torrent"' | sed -e 's/^href="//' -e 's/"$//')"
		if [ -e "$TARGET/$torrent" ] || [ -e "$TARGET/$torrent.added" ]; then
			continue
		fi
		curl -s "$base_url$release$torrent" -o "$TARGET/$torrent"
		echo "$torrent"
	done
done
