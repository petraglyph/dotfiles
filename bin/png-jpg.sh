#!/bin/sh
# PNG to JPG Conversion Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
HELP_TEXT="PNG to JPG Conversion Script

  $ $(basename $0) [directory|file.png]

Providing a directory will convert all PNG files in that directory"


# Check dependencies
if [ -z $(command -v "convert") ]; then
	echo "Command 'convert' not found"
	exit 1
fi


# Convert single file
jpger () {
	if echo $1 | grep -qE ".png$"; then
		jpg=$(echo $1 | sed "s/\.png$/.jpg/")
		echo "$1 -> $jpg"
		convert "$1" "$jpg"
	else
		echo "$1 is not a PNG file"
	fi
}


# File selection
if [ $# -gt 0 ]; then
	if [ ! -z $(echo $1 | grep -oE '^-*[hH](elp|)$') ]; then
		echo "$HELP_TEXT"
		exit 0
	fi
	if [ -d "$1" ]; then
		if [ $(find $1 -maxdepth 1 -name "*.png" | wc -l) -ne 0 ]; then
			find "$(realpath -L -- $1)" -maxdepth 1 -name "*.png" | while read -r f; do
				jpger "$f"
			done
		else
			echo "No PNG files found in $(realpath -L -- $1)"
			exit 1
		fi
	elif [ -f "$1" ]; then
		jpger "$1"
	else
		echo "No such file or directory $(realpath -mL -- $1)"
		exit 1
	fi
else
	if [ $(find . -maxdepth 1 -name "*.png" | wc -l) -ne 0 ]; then
		find . -maxdepth 1 -name "*.png" | while read -r f; do
			jpger "$f"
		done
	else
		echo "No PNG files found"
		exit 1
	fi
fi
