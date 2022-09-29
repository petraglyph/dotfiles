#!/bin/sh
# WEBP to JPG Conversion Script
#   Penn Bauman <me@pennbauman.com>
HELP_TEXT="WEBP to JPG Conversion Script

  $ $(basename $0) [directory|file.webp]

Providing a directory will convert all WEBP files in that directory"


# Check dependencies
if [ -z $(command -v "convert") ]; then
	echo "Command 'convert' not found"
	exit 1
fi


# Convert single file
jpger () {
	if echo $1 | grep -qE ".webp$"; then
		if [ $(grep -c "ANMF" $1) -ne 0 ]; then
			echo "WEBP file $1 is animated, cannot convert to JPG"
		else
			jpg=$(echo $1 | sed "s/\.webp$/.jpg/")
			echo "$1 -> $jpg"
			convert "$1" "$jpg"
		fi
	else
		echo "$1 is not a WEBP file"
	fi
}


# File selection
if [ $# -gt 0 ]; then
	if [ ! -z $(echo $1 | grep -oE '^-*[hH](elp|)$') ]; then
		echo "$HELP_TEXT"
		exit 0
	fi
	if [ -d "$1" ]; then
		if [ $(find $1 -maxdepth 1 -name "*.webp" | wc -l) -ne 0 ]; then
			for f in $(realpath -L -- $1)/*.webp; do
				jpger "$f"
			done
		else
			echo "No WEBP files found in $(realpath -L -- $1)"
			exit 1
		fi
	elif [ -f "$1" ]; then
		jpger "$1"
	else
		echo "No such file or directory $(realpath -mL -- $1)"
		exit 1
	fi
else
	if [ $(find . -maxdepth 1 -name "*.webp" | wc -l) -ne 0 ]; then
		for f in *.webp; do
			jpger "$f"
		done
	else
		echo "No WEBP files found"
		exit 1
	fi
fi
