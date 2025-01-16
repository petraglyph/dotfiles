#!/bin/sh
# Fedora torrent fetcher
#
# https://torrents.fedoraproject.org/

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

BASE_URL="https://torrents.fedoraproject.org"
newest_version=""
torrents="$(curl -s "$BASE_URL" | grep -oE 'href=".*\.torrent"' | sed -e 's/^href="//' -e 's/"$//')"
echo "$torrents" | grep -E 'Fedora-Workstation-Live-x86_64' | sort -n -r | while read -r url; do
	version="$(echo "$url" | grep -oE '[0-9]+(_Beta)?\.torrent$' | sed -E 's/\.[a-z]+$//')"
	version_num="$(echo "$version" | grep -oE '^[0-9]+')"
	# Continue for newest stable version and new beta if present
	if [ ! -z "$(echo "$version" | grep -o 'Beta')" ]; then
		if [ -z "$newest_version" ]; then
			newest_version="$(($version_num - 1))"
		else
			continue
		fi
	elif [ -z "$newest_version" ]; then
		newest_version="$version_num"
	elif [ $version_num -lt $newest_version ]; then
		continue
	fi
	torrent="$(basename "$url")"

	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$url" -o "$TARGET/$torrent"
	fi
done
