#!/bin/sh
# Numbered Files Formating Script
#   Penn Bauman <me@pennbauman.com>
HELP_TEXT="Numbered Files Formating Script

  $ $(basename $0) [directory]

Formats numbers at the beginning of filenames with appropriate leading zeros"

dirformat () {
	# Check there are numbered files
	if [ $(find "$1" -maxdepth 1 -name "[0-9]*" | wc -l) -eq 0 ]; then
		echo "No files starting with numbers found"
		exit 1
	fi
	# Determine max length of numbers
	max_len=0
	len_regex="[0-9]*"
	while [ $(find "$1" -maxdepth 1 -name "$len_regex" | wc -l) -ne 0 ]; do
		len_regex="[0-9]$len_regex"
		max_len=$(($max_len + 1))
	done
	for f in "$1"/*; do
		file="$(basename "$f")"
		# Check file begins with number
		if [ -z $(echo "$file" | grep -oE '^[0-9]') ]; then
			continue
		fi
		# Determine current number length
		current_len=0
		len_regex="^[0-9]"
		while [ ! -z $(echo "$file" | grep -oE "$len_regex") ]; do
			len_regex="$len_regex[0-9]"
			current_len=$(($current_len + 1))
		done
		# Determine padding
		i=$(($max_len - $current_len))
		padding=""
		while [ "$i" -ne 0 ]; do
			padding="0$padding"
			i=$(($i - 1))
		done
		# Rename file if necessary
		if [ ! -z "$padding" ]; then
			mv "$f" "$(dirname "$f")/$padding$file"
		fi
	done
}

# Determine directory to run on
if [ $# > 0 ]; then
	# Check for help option
	if [ ! -z $(echo $1 | grep -oE '^-*[hH](elp|)$') ]; then
		echo "$HELP_TEXT"
		exit 0
	fi
	if [ -d "$1" ]; then
		dirformat "$1"
	else
		echo "Invalid directory"
		exit 1
	fi
else
	dirformat $(pwd)
fi
