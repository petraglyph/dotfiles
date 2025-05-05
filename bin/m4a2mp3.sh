#!/bin/sh
# FLAC to MP3 Conversion Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
export SOURCE_END=".m4a"
export SOURCE_NAME="M4A"
export TARGET_END=".mp3"
export TARGET_NAME="MP3"
export SCRIPT_CMD="$(basename "$0")"


# Check dependencies
if [ -z "$(command -v ffmpeg)" ]; then
	echo "Command 'ffmpeg' not found"
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

	ffmpeg -i "$1" -b:a 320k "$2" > /dev/null 2> /dev/null
	exit $?
fi


aaa2bbb.sh $0 $@
