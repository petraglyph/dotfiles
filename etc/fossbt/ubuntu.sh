#!/bin/sh
# Ubuntu torrent fetcher
#
# https://ubuntu.com/download/alternative-downloads
# https://torrent.ubuntu.com

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

BASE_URL="https://releases.ubuntu.com"
state="start"
releases="$(curl -s "$BASE_URL" | while read -r l; do
	if [ $state = "start" ]; then
		if [ -z "$(echo "$l" | grep 'LTS Releases')" ]; then
			continue
		fi
		state="lts"
	elif [ $state = "lts" ]; then
		release="$(echo "$l" | grep -oE 'href="[a-z]+/".*[0-9]+(\.[0-9]+)+ LTS')"
		if [ -z "$release" ]; then
			continue
		fi
		echo "$(echo "$release" | sed -E -e 's/^href="//' -e 's/\/" .*$//')"
		state="gap"
	elif [ $state = "gap" ]; then
		if [ ! -z "$(echo "$l" | grep 'Interim Releases')" ]; then
			state="interim"
		fi
	elif [ $state = "interim" ]; then
		release="$(echo "$l" | grep -oE 'href="[a-z]+/".*[0-9]+(\.[0-9]+)+')"
		if [ -z "$release" ]; then
			if [ ! -z "$(echo "$l" | grep 'Extended')" ]; then
				break
			fi
			continue
		fi
		echo "$(echo "$release" | sed -E -e 's/^href="//' -e 's/\/" .*$//')"
	fi
done)"

TORRENT_REGEX='>[a-z]?ubuntu-[.0-9]+-desktop-amd64\.iso\.torrent<'
for r in $releases; do
	torrent="$(curl -s "$BASE_URL/$r/"| grep -oE "$TORRENT_REGEX" | sed 's/[<>]//g')"
	if [ -z "$torrent" ]; then
		continue
	fi
	# Check release order
	release_num="$(echo "$torrent" | grep -oE '[0-9]{2}.[0-9]{2}')"
	release_year="$(echo "$release_num" | grep -oE '^[0-9]{2}')"
	if [ -z "$lts_year" ]; then
		lts_year="$(echo "$release_num" | grep -oE -e '^[0-9][02468]\.04$' | sed 's/\.04//')"
	else
		if [ $release_year -lt $lts_year ]; then
			break
		fi
	fi

	# Standard ISO
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$BASE_URL/$r/$torrent" -o "$TARGET/$torrent"
	fi

	xubuntu_url="https://torrent.ubuntu.com/xubuntu/releases/$r/release/desktop/"
	torrent="$(curl -s "$xubuntu_url" | grep -oE "$TORRENT_REGEX" | sed 's/[<>]//g')"
	if [ ! -e "$TARGET/$torrent" ] && [ ! -e "$TARGET/$torrent.added" ]; then
		echo "$torrent"
		curl -s "$xubuntu_url$torrent" -o "$TARGET/$torrent"
	fi
done
