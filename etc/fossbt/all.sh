#!/bin/sh
# All torrent fetchers
ROOT_DIR="$(dirname "$(realpath "$0")")"
SCRIPTS="
bunsenlabs
debian
fedora
kali
linuxmint
tails
ubuntu
"
FORMAT="\033[1;34m%s\033[0m\n"

# Check and create target directory
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

# Check if --log option is used
if [ "$2" = "--log" ]; then
	FORMAT=""
	date '+[%Y-%m-%d %H:%M:%S]'
fi
# Run torrent fetching scripts
for s in $SCRIPTS; do
	printf "$FORMAT" "$s.sh fetching torrents"
	$ROOT_DIR/$s.sh $TARGET
done
