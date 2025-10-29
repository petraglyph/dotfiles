#!/bin/sh
# Rotate Images to Vertical
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

TMP=$(mktemp)
echo 0 > $TMP


# Check required commands are available
missing=""
for cmd in convert exiftool; do
	if [ -z "$(command -v $cmd)" ]; then
		echo "Command '$cmd' not found"
		missing="$cmd"
	fi
done
if [ ! -z "$missing" ]; then exit 1; fi


rotater () {
	if [ -d "$1" ]; then
		find "$1" -maxdepth 1 -mindepth 1 | while read -r f; do
			if [ "$(file --mime-type -Lb "$f" | cut -d"/" -f 1)" = "image" ]; then
				rotater "$f"
			fi
		done
		return 0
	elif [ ! -f "$1" ]; then
		echo "Not a file '$1'"
		exit 1
	fi

	num="$(exiftool -Orientation -n "$1" | cut -d ":" -f 2 | xargs)"
	if echo "$num" | grep -qE '^[0-9]$'; then
		if [ $num -eq 1 ]; then
			deg=0
		fi
		if [ $num -eq 3 ]; then
			deg=180
		elif [ $num -eq 6 ]; then
			deg=90
		elif [ $num -eq 8 ]; then
			deg=270
		fi
		if [ $deg -ne 0 ]; then
			convert "$1" -rotate $deg "$1"
			exiftool -n -m -Orientation='1' "$1" > /dev/null
			rm -f "$1_original"
			echo "$(($(cat $TMP) + 1))" > $TMP
		fi
		printf "%3ddeg %d %s\n" $deg $num "$1"
		return 0
	elif [ -z "$num" ]; then
		echo "    - $1"
		return 1
	else
		echo "Invalid orientation '$num' for '$1'"
		return 1
	fi
}


# File selection
if [ $# -gt 0 ]; then
	if [ -d "$1" ]; then
		rotater "$1"
	elif [ -f "$1" ]; then
		rotater "$1"
	else
		echo "No such file or directory '$1'"
		exit 1
	fi
else
	rotater .
fi


if [ $(cat $TMP) -eq 0 ]; then
	echo "No image files rotated"
else
	echo "$(cat $TMP) image files rotated"
fi
