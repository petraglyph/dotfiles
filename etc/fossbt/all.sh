#!/bin/sh
# All torrent fetchers

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

for f in $(dirname "$(readlink -f "$0")")/*; do
	if [ "$(basename "$f")" = "all.sh" ]; then
		continue
	fi
	printf "\033[1;34m%s\033[0m\n" "$(basename "$f") fetching torrents"
	$f $@
done
