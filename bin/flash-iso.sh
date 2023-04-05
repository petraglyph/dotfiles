#!/bin/sh
# Write ISO to flash drive
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ $# -eq 0 ]; then
	echo "Missing ISO file"
	echo "Usage: $(basename $0) [file.iso] <device>"
	exit 1
fi

image="$1"
if [ -d $image ]; then
	echo "'$image' is a directory not a file"
	exit 1
fi

if [ ! -f $image ]; then
	echo "ISO file not found '$image'"
	exit 1
fi

check_device () {
	if [ -e "$1" ]; then
		dev="$1"
	elif [ -e "/dev/$1" ]; then
		dev="/dev/$1"
	else
		echo "Unknown device '$1'" >&2
		exit 1
	fi

	if [ ! -z "$(grep -oE "($(lsblk -n -o UUID "$dev" | sed -z 's/\n/|/g'))" /etc/fstab)" ]; then
		while true; do
			read -p "$dev was found in /etc/fstab
Are you sure you want to write to $dev? [y/n] " yn
			case $yn in
				y|Y|yes) break ;;
				n|N|no) exit 1 ;;
				*) echo "Please enter 'y' or 'n'" ;;
			esac
		done
	fi

	if [ ! -z "$(lsblk -n -o MOUNTPOINTS "$dev")" ]; then
		for d in $(lsblk -n -o PATH "$dev"); do
			while true; do
				sudo umount -A "$d" &> /dev/null
				if [ $? -ne 0 ]; then
					break
				fi
			done
		done
	fi
	echo "$dev"
}

if [ $# -eq 2 ]; then
	device=$(check_device "$2")
	if [ $? -ne 0 ]; then
		exit 1
	fi
else
	echo "Available device:"
	lsblk -n -d -l -p -o NAME,SIZE | grep '^/dev/sd'
	echo
	echo "Enter 'all' to print all devices or 'quit' to exit"
	while true; do
		read -p "Enter install device: " d
		case $d in
			a|A|all) lsblk -n -d -l -p -o NAME,SIZE ; echo ;;
			q|Q|quit) exit 0 ;;
			*) device=$(check_device "$d")
				if [ $? -eq 0 ]; then
					break
				fi ;;
		esac
	done
fi

echo
echo "Flashing ISO ..."
sudo dd if=$image of=$device bs=4M status=progress oflag=direct
