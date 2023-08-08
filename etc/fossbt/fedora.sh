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
curl -s "$BASE_URL" | grep -oE 'href=".*\.torrent"' | sed -e 's/^href="//' -e 's/"$//' | grep -E '(x86_64|aarch64)' | grep -E -e 'Fedora-(Workstation|Server|KDE|Xfce)' -e "ostree" | while read -r url; do
	version="$(echo "$url" | grep -oE '[0-9]+(_Beta)?\.torrent$' | sed -E 's/\.[a-z]+$//')"
	version_num="$(echo "$version" | grep -oE '^[0-9]+')"
	# Check version is newest or second newest (not counting beta versions)
	if [ ! -z "$(echo "$version" | grep -o 'Beta')" ]; then
		newest_version="$(($version_num - 1))"
	elif [ -z "$newest_version" ]; then
		newest_version="$version_num"
	elif [ $version_num -lt $newest_version ]; then
		break
	fi
	torrent="$(basename "$url")"

	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$url" -o "$TARGET/$torrent"
	fi
done
