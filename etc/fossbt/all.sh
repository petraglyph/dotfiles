#!/bin/sh
# All torrent fetchers
ROOT_DIR="$(dirname "$(realpath "$0")")"
SCRIPTS="
bunsenlabs
debian
elementary
fedora
kali
linuxmint
raspbian
tails
ubuntu
"

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

for s in $SCRIPTS; do
	printf "\033[1;34m%s\033[0m\n" "$s.sh fetching torrents"
	$ROOT_DIR/$s.sh $@
done
