#!/bin/sh

CODEC_OPTS="'x264', 'x265', or 'av1'"
QUALITY_OPTS="'720p' or '1080p'"
HELP_TEXT="Video File Re-Encoding Script

  $ $(basename $0) <options> [target]

Options:
  --help, -h               Print this help message
  --codec, -c [codec]      Required, options: $CODEC_OPTS
  --quality, -q [quality]  Options: $QUALITY_OPTS
  --output, -o [path]      Location to place video outputs
  --verbose, -v            Print detailed information
"

# Check for ffmpeg
if [ -z "$(command -v ffmpeg)" ]; then
	echo "Missing dependency ffmpeg"
	exit 1
fi

# Read command line options
VERBOSE="no"
if [ $# -gt 0 ]; then
	GET_VALUE=""
	for arg in "$@"; do
		if [ ! -z $GET_VALUE ]; then
			case $GET_VALUE in
				--codec|-c) CODEC_ARG="$arg" ;;
				--quality|-q) QUALITY_ARG="$arg" ;;
				--output|-o) OUTPUT_LOC="$arg" ;;
				*) echo "UNREACHABLE CODE ($$GET_VALUE case)"; exit 1 ;;
			esac
			GET_VALUE=""
			continue
		fi

		if [ ! -z $(echo $arg | grep -oE '^-*[hH](elp|)$') ]; then
			echo "$HELP_TEXT"
			exit 0
		fi

		if [ -z "$(echo "$arg" | grep -E '^-')" ]; then
			# SOURCE_LOC="$arg\n$SOURCE_LOC"
			if [ -z "$SOURCE_LOC" ]; then
				SOURCE_LOC="$arg"
			else
				echo "Only one target allowed"
				exit 1
			fi
		else
			case $arg in
				--codec|-c) GET_VALUE="$arg" ;;
				--quality|-q) GET_VALUE="$arg" ;;
				--output|-o) GET_VALUE="$arg" ;;
				--verbose|-v) VERBOSE="YES" ;;
				*) echo "Unknown arguement '$arg'"
					exit 1 ;;
			esac
		fi
	done
	# Check if value for option is still required
	case $GET_VALUE in
		"" ) ;;
		--codec|-c) echo "Missing codec for '$GET_VALUE' option" ; exit 1 ;;
		--quality|-q) echo "Missing quality for '$GET_VALUE' option" ; exit 1 ;;
		*) echo "UNREACHABLE CODE ($$GET_VALUE case)"; exit 1 ;;
	esac
fi


# Check target
if [ -z "$SOURCE_LOC" ]; then
	echo "Target required"
	exit 1
elif [ ! -e "$SOURCE_LOC" ]; then
	echo "Target '$SOURCE_LOC' not found"
	exit 1
fi

# Check codec
if [ -z "$CODEC_ARG" ]; then
	echo "A codec must be provided with --codec (or -c)"
	echo "Valid options are $CODEC_OPTS"
	exit 1
fi
case "$(echo "$CODEC_ARG" | tr A-Z a-z)" in
	libx264|x264) CODEC_STR="x264" ;;
	libx265|x265) CODEC_STR="x265" ;;
	libaom-av1|aom-av1|av1) echo TODO ; exit 1
		CODEC="libaom-av1" ; CODEC_PRETTY="av1" ;;
	*) echo "Invalid codec '$CODEC_ARG'"
		echo "Valid options are $CODEC_OPTS"
		exit 1 ;;
esac

# Check quality
if [ -z "$QUALITY_ARG" ]; then
	if [ ! -z "$(echo "$SOURCE_LOC" | grep 1080)" ]; then
		QUALITY_ARG=1080
	elif [ ! -z "$(echo "$SOURCE_LOC" | grep 720)" ]; then
		QUALITY_ARG=720
	else
		echo "Quality not provided and could not be determined"
		exit 1
	fi
fi
case "$(echo "$QUALITY_ARG" | tr A-Z a-z)" in
	'') ;;
	720|720p) QUALITY_NUM="720" ;;
	1080|1080p) QUALITY_NUM="1080" ;;
	*) echo "Invalid quality '$QUALITY_ARG'"
		echo "Valid options are $QUALITY"
		exit 1 ;;
esac


# recode_dir codec quality target output
recode_dir () {
	mkdir -p "$4"
	printf "\033[1;34m%s\033[0m %s -> %s\n" " [DIR]" "$(realpath --relative-base="$PWD" "$3")" "$(realpath -m --relative-base="$PWD" "$4")"

	for f in "$3"/*; do
		if [ -f "$f" ]; then
			recode $1 $2 "$f" "$4"
			n=$?
			if [ $n -gt 0 ]; then
				return $n
			fi
		elif [ -d "$f" ]; then
			recode_dir $1 $2 "$f" "$4/$(basename "$f")"
			n=$?
			if [ $n -gt 0 ]; then
				return $n
			fi
		else
			echo "UNREACHABLE CODE (recusive SOURCE_LOC not file or dir)"
			echo "  '$f'"
		fi
	done
}

# recode codec quality output
recode () {
	codec="lib$1"
	quality="hd${2}"
	src="$3"
	output="$4"

	pretty_str="${2}p.$1.recode"
	if [ -z "$(basename "$src" | grep -oE "\([0-9]+p\)")" ]; then
		target="$output/$(basename "$src" | sed -E 's/\.[a-z0-9]+$//') ($pretty_str)$(basename "$src" | grep -oE '\.[a-z0-9]+$')"
	else
		target="$output/$(basename "$src" | sed "s/(.*)/($pretty_str)/")"
	fi
	name="$(basename "$target" | sed -E 's/ \(.*$//')"

	if [ -f "$target" ]; then
		printf "\033[1;33m%s\033[0m %s\n" "[SKIP]" "$name"
		return
	fi
	printf "\033[1;32m%s\033[0m %s\n" "[FILE]" "$name"
	ffmpeg -i "$src" -n -v 24 -stats -c:v $codec -s $quality -crf 30 -c:a aac -strict -2 -metadata title="$name" "$target" < /dev/null
	return
}


# Check output location
if [ -z "$OUTPUT_LOC" ]; then
	OUTPUT_LOC="$(dirname "$(readlink -f "$SOURCE_LOC")")"
	if [ -f "$SOURCE_LOC" ]; then
		recode $CODEC_STR $QUALITY_NUM "$(readlink -f "$SOURCE_LOC")" "$OUTPUT_LOC"
	elif [ -d "$SOURCE_LOC" ]; then
		recode_dir $CODEC_STR $QUALITY_NUM "$(readlink -f "$SOURCE_LOC")" "$OUTPUT_LOC/$(basename "$SOURCE_LOC") (${QUALITY_NUM}-$CODEC_STR)"
	else
		echo "UNREACHABLE CODE (SOURCE_LOC not file or dir, no OUTPUT_LOC)"
		echo "  '$SOURCE_LOC'"
	fi
else
	OUTPUT_LOC="$(readlink -f "$OUTPUT_LOC")"
	if [ ! -d "$OUTPUT_LOC" ]; then
		if [ -e "$OUTPUT_LOC" ]; then
			echo "'$OUTPUT_LOC' already exists but is not a directory"
			exit 1
		fi
		mkdir -p "$OUTPUT_LOC"
		if [ ! -d "$OUTPUT_LOC" ]; then
			echo "Creating output directory failed"
			exit 1
		fi
	fi

	if [ -f "$SOURCE_LOC" ]; then
		recode $CODEC_STR $QUALITY_NUM "$(readlink -f "$SOURCE_LOC")" "$OUTPUT_LOC"
		exit
	elif [ -d "$SOURCE_LOC" ]; then
		recode_dir $CODEC_STR $QUALITY_NUM "$(readlink -f "$SOURCE_LOC")" "$OUTPUT_LOC"
		exit
	else
		echo "UNREACHABLE CODE (SOURCE_LOC not file or dir, -o OUTPUT_LOC)"
		echo "  '$SOURCE_LOC'"
	fi
fi
