#!/bin/sh
# Date Image File Names From Metadata
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

MEDIA_ENDERS=".*\.(jpg|png|mp4|mov)$"
TMP=$(mktemp)
echo 0 > $TMP


# Check dependencies
if [ -z $(command -v "exiftool") ]; then
	echo "Command 'exiftool' not found"
	exit 1
fi


mediadate () {
	if [ -d "$1" ]; then
		find "$1" -maxdepth 1 -mindepth 1 -regextype egrep -iregex "$MEDIA_ENDERS" | while read -r f; do
			mediadate "$f"
		done
		return 0
	elif [ ! -f "$1" ]; then
		echo "Not a file '$1'"
		exit 1
	fi

	# Get info from file
	ender="$(echo "$1" | sed 's/.*\.//' | tr A-Z a-z)"
	date=$(exiftool "$1" -DateTimeOriginal)
	if [ -z "$date" ]; then
		date=$(exiftool "$1" -CreateDate)
	fi
	if [ -z "$date" ]; then
		echo "Cannot determine date for '$1'"
		exit 1
	fi

	# Generate new file name
	datefmt="$(echo $date | sed -E -e 's/^[A-Za-z \/]*: //' -e 's/:/-/g' -e 's/ /_/g')"
	file="$(dirname "$1")/$datefmt.$ender"
	if [ "$file" = "$1" ]; then
		return 0
	fi

	# Change new file name to avoid conflicts
	c="b"
	while [ -f "$file" ]; do
		if [ "$c" = "z" ]; then
			break
		fi
		file="$(dirname "$1")/${datefmt}_$c.$ender"
		c="$(echo $c | tr a-z b-za)"
	done
	i=1
	while [ -f "$file" ]; do
		file="$(dirname "$1")/${datefmt}_$i.$ender"
		i=$(($i + 1))
	done
	echo "$1 -> $file"
	mv "$1" "$file"
	echo "$(($(cat $TMP) + 1))" > $TMP
	return 0
}

checkmedia () {
	if [ -d "$1" ]; then
		if [ -z "$(find "$1" -maxdepth 1 -mindepth 1 -regextype 'egrep' -iregex "$MEDIA_ENDERS")" ]; then
			echo "No media found in '$1'"
			return 1
		fi
	elif [ -f "$1" ]; then
		if [ -z "$(echo "$1" | grep -iE "$MEDIA_ENDERS")" ]; then
			echo "'$1' No a media file"
			return 1
		fi
	else
		echo "checkmedia() '$1' not a file or directory"
		exit 2
	fi
}

# File selection
if [ $# -gt 0 ]; then
	if [ -d "$1" ]; then
		checkmedia "$1"
		if [ $? -ne 0 ]; then
			exit 0
		fi
		mediadate "$1"
	elif [ -f "$1" ]; then
		checkmedia "$1"
		if [ $? -ne 0 ]; then
			exit 1
		fi
		mediadate "$1"
	else
		echo "No such file or directory '$1'"
		exit 1
	fi
else
	checkmedia .
	if [ $? -ne 0 ]; then
		exit 0
	fi
	mediadate .
fi


if [ $(cat $TMP) -eq 0 ]; then
	echo "No media files dated"
else
	echo "$(cat $TMP) media files dated"
fi
