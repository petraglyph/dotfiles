#!/bin/sh
# Format torrent files with name and hash filenames
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
HELP_STR="
Usage:
  $(basename "$0") -l|--list DIRECTORY      List formatted torrent file names
  $(basename "$0") -i|--inplace DIRECTORY   Format torrent file within directory
  $(basename "$0") SOURCE TARGET            Copy formatted torrent files to directory"
EXAMPLE="Fedora-i3-Live-x86_64-37.895587962ffcd23acdfdae81aeba4b2cff9988b7.torrent"

fileinc () {
	if [ -f "$TMP/$1" ]; then
		sum=$(($(cat "$TMP/$1") + 1))
		echo $sum > "$TMP/$1"
	else
		echo 1 > "$TMP/$1"
	fi
}
fileget () {
	if [ -f "$TMP/$1" ]; then
		cat "$TMP/$1"
	else
		echo 0
	fi
}

if [ -z "$(command -v transmission-show)" ]; then
	echo "Missing dependency 'transmission-show'"
	exit 1

fi


if [ $# -eq 0 ] || [ ! -z "$(echo "$1" | grep -oE '^-+[hH](elp|)$')" ]; then
	echo "Torrent Files Formatter"
	echo
	echo "  Converts torrent files to 'name.hash.torrent' format, using torrent metadata."
	echo "  Example: '$EXAMPLE'"
	echo "$HELP_STR"
	exit 0
fi
if [ -z "$(echo "$1" | grep -oE '^-')" ]; then
	SOURCE="$1"
else
	case "$1" in
		-l|--list) OPTION="LIST" ;;
		-i|--inplace) OPTION="INPLACE" ;;
		*) echo "Unknown option '$1'"
			echo "$HELP_STR"
			exit 1 ;;
	esac
fi
if [ $# -eq 1 ]; then
	echo "Missing target directory"
	echo "$HELP_STR"
	exit 1
fi
if [ -z "$OPTION" ]; then
	TARGET="$2"
else
	SOURCE="$2"
fi


# Check directories
if [ ! -d "$SOURCE" ]; then
	if [ -e "$SOURCE" ]; then
		echo "Source not a directory"
	fi
	echo "Source directory does not exists"
	exit 1
fi
if [ ! -z "$TARGET" ]; then
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
fi

# Check for torrent files
if [ -z "$(find "$SOURCE" -maxdepth 1 -name '*.torrent')" ]; then
	echo "No torrent files found in directory"
	exit 0
fi

# Copy torrent files with new names
TMP=$(mktemp -d)
find "$SOURCE" -maxdepth 1 -name '*.torrent' | sort | while read -r f; do
	name="$(transmission-show "$f" | grep -E '^  Name:' | sed -E 's/  [A-Za-z]+: //')"
	asciiname="$(echo "$name" | iconv -f utf-8 -t ascii//translit | tr '?!:*/' ____)"
	hash="$(transmission-show "$f" | grep -E '^  Hash' | head -n 1 | grep -oE '[a-f0-9]+$')"
	new="$asciiname.$hash.torrent"

	if [ -z "$OPTION" ]; then
		if [ -e "$TARGET/$new" ]; then
			fileinc skipped
		else
			echo "$new"
			cp "$f" "$TARGET/$new"
			if [ $? -ne 0 ]; then
				echo "Copying $new failed"
				rm -rf $TMP
				exit 1
			fi
			fileinc created
		fi
	elif [ "$OPTION" = "LIST" ]; then
		echo "$new"
	elif [ "$OPTION" = "INPLACE" ]; then
		if [ -e "$SOURCE/$new" ]; then
			if [ "$(basename "$f")" = "$new" ]; then
				fileinc skipped
			elif [ -z "$(diff "$f" "$SOURCE/$new")" ]; then
				fileinc deleted
				rm -f "$f"
			else
				echo "$SOURCE/$new already exists"
				rm -rf $TMP
				exit 1
			fi
		else
			echo "$new"
			mv "$f" "$SOURCE/$new"
			if [ $? -ne 0 ]; then
				echo "Copying $new failed"
				rm -rf $TMP
				exit 1
			fi
			fileinc created
		fi
	else
		echo "Unknown \$OPTION"
		rm -rf $TMP
		exit 1
	fi
done

if [ -z "$OPTION" ]; then
	echo "Torrent files backed up ($(fileget created) copied, $(fileget skipped) skipped)"
elif [ "$OPTION" = "INPLACE" ]; then
	echo "Torrent files formatted ($(fileget created) moved, $(fileget skipped) skipped, $(fileget deleted) deleted)"
fi
rm -rf $TMP
