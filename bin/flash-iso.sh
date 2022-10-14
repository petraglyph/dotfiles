#!/bin/sh
# Write ISO to flash drive
#   Penn Bauman <me@pennbauman.com>

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
		if [ ! -z "$(lsblk -n -o MOUNTPOINTS "$1")" ]; then
			sudo umount -A $(lsblk -n -o MOUNTPOINTS "$1")
		fi
		echo "$1"
	elif [ -e "/dev/$1" ]; then
		if [ ! -z "$(lsblk -n -o MOUNTPOINTS "/dev/$1")" ]; then
			sudo umount -A $(lsblk -n -o MOUNTPOINTS "/dev/$1")
		fi
		echo "/dev/$1"
	else
		echo "Unknown device '$1'" >&2
		exit 1
	fi
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
sudo dd if=$image of=$device bs=8M status=progress oflag=direct
