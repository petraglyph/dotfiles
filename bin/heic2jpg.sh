#!/bin/sh
# HEIC to JPEG Conversion Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
export SOURCE_END=".heic"
export SOURCE_NAME="HEIC"
export TARGET_END=".jpg"
export TARGET_NAME="JPEG"
export SCRIPT_CMD="$(basename "$0")"


# Check dependencies
if [ -z "$(command -v magick)" ]; then
	echo "Command 'magick' not found"
	exit 1
fi

# Convert if source and target files are provided
if [ $# -eq 2 ] && [ -f "$1" ] && [ -d "$(dirname "$2")" ]; then
	if [ -z "$(echo "$1" | grep -iE "$SOURCE_END$")" ]; then
		echo "'$1' is not a $SOURCE_NAME file"
		exit 1
	fi
	if [ -z "$(echo "$2" | grep -E "$TARGET_END$")" ]; then
		echo "'$2' is not a $TARGET_NAME file"
		exit 1
	fi

	magick "$1" "$2"
	exit $?
fi


aaa2bbb.sh $0 $@
