#!/bin/sh
# Alpine Linux Chroot
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
CLI_NAME="$(basename "$0" | sed 's/\..*$//')"
HELP_TEXT="Alpine Linux Chroot Wrapper

  $ $(basename "$0") [OPTIONS] [NAME]

Chroot Name:
  If a name is provided, a chroot with that name is created if it does not yet
  exist and entered. If no name is provided, a temporary chroot is created,
  used, and deleted when you exit.

Options:
  -l, --list      List existing chroots and their versions
  -d, --delete    Delete the specified chroot
  -v, --verbose   Print detailed messages
  -h, --help      Print this help message
"
SOURCE_BASE_URL="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$(uname -m)"
VAR_DIR="$HOME/.local/state/$CLI_NAME"
ALPINE_CACHE="$HOME/.cache/alpinelinux"
mkdir -p "$VAR_DIR/roots" "$ALPINE_CACHE"


verboseecho () {
	if [ "$VERBOSE" = "TRUE" ]; then
		echo $@
	fi
}
printchroot () {
	if [ -f "$1"/etc/alpine-release ]; then
		printf "%-20s %s\n" "$(basename "$1")" "$(cat $1/etc/alpine-release)"
	else
		echo "Unknown chroot '$1'"
	fi
}


# Check command line argument
LIST="false"
DELETE="false"
VERBOSE="false"
if [ $# -gt 0 ]; then
	for arg in "$@"; do
		if [ ! -z "$(echo "$arg" | grep -oE '^-*[hH](elp|)$')" ]; then
			echo "$HELP_TEXT"
			exit 0
		fi
		# Check for non-option parameters
		if [ -z "$(echo "?$arg" | grep -oE '^\?-')" ]; then
			if [ ! -z "$chroot_name" ]; then
				echo "Unused argument '$arg'" 1>&2
				exit 1
			elif [ -z "$(echo "$arg" | grep -oE '^[[:alnum:]]([-_.a-zA-Z0-9]*[[:alnum:]]|)$')" ]; then
				echo "Invalid name '$1', must start and end with an alphanumeric character and" 1>&2
				echo " contain only alphanumerics, '-', '_', and '.'." 1>&2
				exit 1
			else
				chroot_name="$arg"
			fi
		# Check options
		else
			case "$arg" in
				-l|--list) LIST="TRUE" ;;
				-d|--delete) DELETE="TRUE" ;;
				-v|--verbose) VERBOSE="TRUE" ;;
				*) echo "Unknown option '$arg'" 1>&2
					exit 1 ;;
			esac
		fi
	done
fi

# List chroots
if [ "$LIST" = "TRUE" ]; then
	if [ -z "$chroot_name" ]; then
		find "$VAR_DIR/roots" -mindepth 1 -maxdepth 1 | while read -r d; do
			printchroot "$d"
		done
	else
		printchroot "$VAR_DIR/roots/$chroot_name"
	fi
	exit 0
fi

# Delete chroot
if [ "$DELETE" = "TRUE" ]; then
	if [ -z "$chroot_name" ]; then
		echo "Chroot name must be provided for --delete option" 1>&2
		exit 1
	elif [ -d "$VAR_DIR/roots/$chroot_name" ]; then
		verboseecho "Removing chroot '$chroot_name' ..."
		rm -rf "$VAR_DIR/roots/$chroot_name"
		exit 0
	else
		echo "Chroot '$chroot_name' does not exists" 1>&2
		exit 1
	fi
fi

# Determine chroot location
if [ -z "$chroot_name" ]; then
	chroot_dir="$(mktemp -u "/tmp/$CLI_NAME-XXXXXXXX")"
else
	chroot_dir="$VAR_DIR/roots/$chroot_name"
fi

# Create chroot if necessary
if [ ! -d "$chroot_dir" ]; then
	# Determine latest version of Alpine
	if [ -z "$(find "$VAR_DIR" -cmin -90 -name 'latest')" ]; then
		verboseecho "Checking latest Alpine version from '$SOURCE_BASE_URL' ..."
		RELEASE_TAR="$(curl -s "$SOURCE_BASE_URL/" | grep -E '"alpine-minirootfs-[.0-9]+-[_a-z0-9]+\.tar\.gz"' | sed -e 's/^.*<a href="//' -e 's/">alpine.*$//' | tail -n 1)"
		echo "$RELEASE_TAR" > "$VAR_DIR/latest"
	else
		verboseecho "Found cached Alpine version in '$VAR_DIR/latest'"
		RELEASE_TAR="$(cat "$VAR_DIR/latest")"
	fi
	if [ -z "$(echo "$RELEASE_TAR" | grep -oE '^alpine-minirootfs-[.0-9]+-[_a-z0-9]+\.tar\.gz$')" ]; then
		echo "Improper Alpine release tarball '$RELEASE_TAR'" 1>&2
		exit 1
	fi
	# Download minirootfs if necessary
	if [ ! -e "$ALPINE_CACHE/$RELEASE_TAR" ]; then
		verboseecho "Downloading $RELEASE_TAR ..."
		curl --silent "$SOURCE_BASE_URL/$RELEASE_TAR" > "$ALPINE_CACHE/$RELEASE_TAR"
	fi
	touch "$ALPINE_CACHE/$RELEASE_TAR"
	if [ -e "$chroot_dir" ]; then
		echo "Something already exists in '$chroot_dir'" 1>&2
		exit 1
	fi

	verboseecho "Extracting $RELEASE_TAR ..."
	tar --one-top-level="$chroot_dir" --extract --file "$ALPINE_CACHE/$RELEASE_TAR"
	echo 'nameserver 1.1.1.1' > "$chroot_dir/etc/resolv.conf"
fi

# Enter chroot
if [ -z "$chroot_name" ]; then
	verboseecho "Entering temporary chroot '$(echo "$chroot_dir" | grep -oE '[[:alnum:]]+$')'"
	unshare --map-root-user --root="$chroot_dir" env -i sh
	rm -rf "$chroot_dir"
else
	verboseecho "Entering chroot '$chroot_name'"
	unshare --map-root-user --root="$chroot_dir" env -i sh
fi
