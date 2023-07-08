#!/bin/sh
# AAA to BBB Generic Conversion Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
TMP="$(mktemp)"
if [ -z "$SOURCE_END" ]; then
	SOURCE_END=".aaa"
fi
if [ -z "$SOURCE_NAME" ]; then
	SOURCE_NAME="AAA"
fi
if [ -z "$TARGET_END" ]; then
	TARGET_END=".bbb"
fi
if [ -z "$TARGET_NAME" ]; then
	TARGET_NAME="BBB"
fi
if [ -z "$SCRIPT_CMD" ]; then
	SCRIPT_CMD="$(basename "$0")"
fi
A2B_USAGE_TEXT="
Usage:
  $SCRIPT_CMD -l|--list DIRECTORY      List conversions to be preformed
  $SCRIPT_CMD -i|--inplace DIRECTORY   Convert files within directory, creating backup-### directory
  $SCRIPT_CMD SOURCE TARGET            Convert $SOURCE_NAME files to $TARGET_NAME files in a different directory"
A2B_HELP_TEXT="$SOURCE_NAME to $TARGET_NAME Conversion Script

Converts a directory of $SOURCE_NAME files to $TARGET_NAME files, does not delete originals
$A2B_USAGE_TEXT"


# Check command line arguments
if [ $# -eq 0 ]; then
	echo "$(basename "$0"): Missing script"
	exit 1
elif [ ! -x $1 ]; then
	echo "$(basename "$0"): Script '$1' is not executable"
	exit 1
elif [ $# -eq 1 ]; then
	echo "$A2B_HELP_TEXT"
	exit 0
else
	for arg in "$@"; do
		if [ ! -z $(echo "$arg" | grep -oE '^-+[hH](elp|)$') ]; then
			echo "$A2B_HELP_TEXT"
			exit 0
		fi
	done
fi
if [ -z "$(echo "$2" | grep -oE '^-')" ]; then
	A2B_SOURCE="$2"
else
	case "$2" in
		-l|--list) A2B_OPTION="LIST" ;;
		-i|--inplace) A2B_OPTION="INPLACE" ;;
		*) echo "Unknown option '$2'"
			echo "$HELP_STR"
			exit 1 ;;
	esac
fi
if [ $# -eq 2 ]; then
	echo "Missing target directory"
	echo "$A2B_USAGE_TEXT"
	exit 1
fi
if [ -z "$A2B_OPTION" ]; then
	A2B_TARGET="$3"
else
	A2B_SOURCE="$3"
fi


# Check directories
if [ ! -d "$A2B_SOURCE" ]; then
	if [ -e "$A2B_SOURCE" ]; then
		echo "Source '$A2B_SOURCE' is not a directory"
	fi
	echo "Source directory '$A2B_SOURCE' does not exists"
	exit 1
fi
if [ ! -z "$A2B_TARGET" ]; then
	if [ ! -d "$A2B_TARGET" ]; then
		if [ -e "$A2B_TARGET" ]; then
			echo "'$A2B_TARGET' already exists but is not a directory"
			exit 1
		fi
		mkdir -p "$A2B_TARGET"
		if [ ! -d "$A2B_TARGET" ]; then
			echo "Creating target directory failed"
			exit 1
		fi
	fi
fi


# Check for torrent files
if [ -z "$(find "$A2B_SOURCE" -maxdepth 1 -name "*$SOURCE_END")" ]; then
	echo "No $SOURCE_NAME files found in '$A2B_SOURCE'"
	exit 0
fi

# Create backup directory
if [ "$A2B_OPTION" = "INPLACE" ]; then
	A2B_BACKUP_DIR="$(mktemp -d -p "$A2B_SOURCE" backup-XXX)"
fi
find "$A2B_SOURCE" -maxdepth 1 -name "*$SOURCE_END" | sort > $TMP
while true; do
	# Get next file name
	f="$(cat $TMP | head -n 1)"
	sed -i '1d' $TMP

	if [ -z "$f" ]; then
		break
	fi
	if [ ! -f "$f" ]; then
		echo "Files '$f' does not exists"
		exit 1
	fi
	file="$(basename "$f")"
	new="$(echo "$file" | sed -E "s/\\$SOURCE_END$/$TARGET_END/")"
	
	# Convert files
	if [ -z "$A2B_OPTION" ]; then
		echo "$f -> $A2B_TARGET/$new"
		$1 "$f" "$A2B_TARGET/$new"
		if [ $? -ne 0 ]; then
			echo "Converting '$f' failed"
			exit 1
		fi
	elif [ "$A2B_OPTION" = "LIST" ]; then
		echo "$(basename "$f") -> $new"
	elif [ "$A2B_OPTION" = "INPLACE" ]; then
		echo "$f -> $A2B_SOURCE/$new"
		$1 "$f" "$A2B_SOURCE/$new"
		if [ $? -ne 0 ]; then
			echo "Converting '$f' failed"
			exit 1
		else
			mv "$f" "$A2B_BACKUP_DIR"
		fi
	fi
done

rm -f $TMP
