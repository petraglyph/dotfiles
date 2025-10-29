#!/bin/sh
# WEBP to JPEG Conversion Script
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
export SOURCE_END=".webp"
export SOURCE_NAME="WEBP"
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
	if [ -z "$(echo "$1" | grep -E "$SOURCE_END$")" ]; then
		echo "'$1' is not a $SOURCE_NAME file"
		exit 1
	fi
	if [ -z "$(echo "$2" | grep -E "$TARGET_END$")" ]; then
		echo "'$2' is not a $TARGET_NAME file"
		exit 1
	fi
	if [ $(grep -c "ANMF" "$1") -ne 0 ]; then
		echo "WEBP file '$1' is animated, cannot convert to JPG"
	fi

	magick "$1" "$2"
	exit $?
fi


aaa2bbb.sh $0 $@
