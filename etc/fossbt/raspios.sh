#!/bin/sh
# Raspberry Pi OS torrent fetcher
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

BASE_URL="https://downloads.raspberrypi.org"
for arch in armhf arm64; do
	dir="$BASE_URL/raspios_$arch/images/"
	release="$(curl -s "$dir" | grep -oE 'href="[-_A-Za-z0-9\/]+"' | tail -n 1 | sed -e 's/^href="//' -e 's/"$//')"
	base_torrent_file="$(curl -s "$dir$release" | grep -oE 'href="[-_.A-Za-z0-9]+\.torrent"' | sed -e 's/^href="//' -e 's/"$//')"

	for os in raspios raspios_lite raspios_full; do
		torrent_file="$(echo "$base_torrent_file" | sed "s/-$arch/-$arch$(echo $os | grep -o '_.*' | sed 's/_/-/')/")"
		torrent_url="$(echo "$dir$release" | sed "s/raspios/$os/g")$torrent_file"

		if [ -e "$TARGET/$torrent_file" ] || [ -e "$TARGET/$torrent_file.added" ]; then
			continue
		fi
		curl -s "$torrent_url" -o "$TARGET/$torrent_file"
		echo "$torrent_file"
	done
done
