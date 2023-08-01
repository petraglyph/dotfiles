#!/bin/sh
# Setup Raspbian Image and/or Write to SD Card
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
NAME_CLI="$(basename "$0" | sed 's/\..*$//')"
CACHE_DIR="$HOME/.cache/raspios"
HELP_TEXT="Raspbian Image Setup Script

  $ $(basename $0) <options...>

Options:
  --help, -h           Print this help message
  --write, -w          Write Raspbian image to SD card before setup
  --dev [path]         Device to write image onto
  --autodownload, -d   Automatically download a Raspbian image in necessary
  --image, -i [file]   Specify local Raspbian image to write
  --all                Preform all manual configurations
  --no, -n             Do not ask to preform manual configurations
  --config, -c [file]  Configuration file to autofill settings
  --type, -t [TYPE]    Raspbian type (std/raspios, lite/raspios_lite, or full/raspios_full)
  --arch, -a [ARCH]    Raspbian architecture (armhf/32 or arm64/64)
  --quiet, -q          Don't print progress information

Configuration File Settings:
  USER_ID=\"username\"        Default user on system
  USER_PASSWD=\"password\"    Password for default user
  WIFI_SSID=\"name\"          WiFi network name
  WIFI_PASSWD=\"password\"    WiFi network password
"


# Check required commands are available
missing=""
for cmd in openssl wpa_passphrase wget xz; do
	if [ -z "$(command -v $cmd)" ]; then
		echo "Missing dependency $cmd" 1>&2
		missing="$cmd"
	fi
done
if [ ! -z "$missing" ]; then
	exit 1
fi


# Options
WRITE="no"
DISK=""
AUTODOWNLOAD="no"
IMAGE=""
ALL="no"
NO="no"
CONFIG=""
TYPE="std"
ARCH="armhf"
QUIET="no"

# Read command line options
if [ $# -gt 0 ]; then
	GET_VALUE=""
	for arg in "$@"; do
		if [ ! -z $GET_VALUE ]; then
			case $GET_VALUE in
				--image|-i) IMAGE="$arg" ;;
				--dev) DISK="$arg" ;;
				--config|-c) CONFIG="$arg" ;;
				--type|-t) TYPE="$arg" ;;
				--arch|-a) ARCH="$arg" ;;
				*) echo "UNREACHABLE CODE ($$GET_VALUE case)" 1>&2
					exit 1 ;;
			esac
			GET_VALUE=""
			continue
		fi

		if [ ! -z $(echo $arg | grep -oE '^-*[hH](elp|)$') ]; then
			echo "$HELP_TEXT"
			exit 0
		fi

		case $arg in
			--write|-w) WRITE="YES" ;;
			--dev) GET_VALUE="$arg" ;;
			--autodownload|-d) AUTODOWNLOAD="YES" ;;
			--image|-i) GET_VALUE="$arg" ;;
			--all) ALL="YES" ;;
			--no|-n) NO="YES" ;;
			--config|-c) GET_VALUE="$arg" ;;
			--type|-t) GET_VALUE="$arg" ;;
			--arch|-a) GET_VALUE="$arg" ;;
			--quiet|-q) QUIET="YES" ;;
			*) echo "Unknown arguement '$arg'" 1>&2
				exit 1 ;;
		esac
	done
	# Check if value for option is still required
	if [ ! -z "$GET_VALUE" ]; then
		case $GET_VALUE in
			--image|-i) echo "Missing image file for '$GET_VALUE' option" 1>&2 ;;
			--dev) echo "Missing path file for '$GET_VALUE' option" 1>&2 ;;
			--config|-c) echo "Missing config file for '$GET_VALUE' option" 1>&2 ;;
			--type|-t) echo "Missing OS type for '$GET_VALUE' option" 1>&2 ;;
			--arch|-a) echo "Missing architecture for '$GET_VALUE' option" 1>&2 ;;
			*) echo "UNREACHABLE CODE ($$GET_VALUE case)" 1>&2 ;;
		esac
		exit 1
	fi
fi
if [ "$ALL" = "YES" ] && [ "$NO" = "YES" ]; then
	echo "Cannot specify both --all and --no, they conflict" 1>&2
	exit 1
fi

# Check raspbian type
case $TYPE in
	std|standard|raspios) TYPE="raspios" ;;
	lite|raspios_lite) TYPE="raspios_lite" ;;
	full|raspios_full) TYPE="raspios_full" ;;
	*) echo "Unknown OS type '$TYPE'" 1>&2
		exit 1 ;;
esac
# Check architecture
case $ARCH in
	armhf|hf|32) ARCH="armhf" ;;
	arm64|64|aarch64) ARCH="arm64" ;;
	*) echo "Unknown architecture '$ARCH'" 1>&2
		exit 1 ;;
esac


if [ "$WRITE" = "YES" ]; then
	# Check for image to write, autodownload if necessary
	if [ -z "$IMAGE" ]; then
		base_url="https://downloads.raspberrypi.org/${TYPE}_${ARCH}/images/"
		release="$(curl -s "$base_url" | grep -oE 'href="[-_A-Za-z0-9\/]+"' | tail -n 1 | sed -e 's/^href="//' -e 's/"$//')"
		image="$(curl -s "$base_url$release" | grep -oE 'href="[-_.A-Za-z0-9]+\.img\.xz"' | sed -e 's/^href="//' -e 's/"$//')"
		image_url="$base_url$release$image"
		image_compressed="$CACHE_DIR/$(basename $image_url)"
		image_file=$(echo $image_compressed | sed 's/\.xz$//')

		# Download image if necessary
		if [ ! -f $image_file ]; then
			if [ ! -f $image_compressed ]; then
				if [ ! "$AUTODOWNLOAD" = "YES" ]; then
					echo "No image provided for writing to SD card (--image option is missing)"
					question="Would you like to download Raspbian? [y/n] "
					while true; do
						read -p "$question" c
						case $c in
							y|Y|yes) break ;;
							n|N|no) echo "No image available to write" 1>&2
								exit 0 ;;
							*) echo "  Invalid option, please use 'y' or 'n'" ;;
						esac
						question="Download Raspbian? [y/n] "
					done
				fi

				if [ "$QUIET" = "no" ]; then
					echo "Downloading Raspbian image"
				fi
				mkdir -p $CACHE_DIR
				if [ "$QUIET" = "no" ]; then
					wget -q --show-progress $image_url -O $image_compressed
				else
					wget -q $image_url -O $image_compressed
				fi
				if [ $? -ne 0 ]; then
					rm -f $image_compressed
					echo "Error downloading $image_url" 1>&2
					exit 1
				fi
			fi

			# Decompress image
			if [ "$QUIET" = "no" ]; then
				xz -dv $image_compressed
			else
				xz -dq $image_compressed
			fi
			if [ $? -eq 0 ]; then
				rm -f $image_compressed
			else
				rm -f $image_file
				echo "Error decompressing ~${image_compressed#$HOME}" 1>&2
				exit 1
			fi
			if [ "$QUIET" = "no" ]; then
				echo
				echo "Image downloaded ~${image_file#$HOME}"
			fi
		else
			if [ "$QUIET" = "no" ]; then
				echo "Image found at ~${image_file#$HOME}"
			fi
		fi
		IMAGE="$image_file"
	else
		if [ ! -f "$IMAGE" ]; then
			echo "Cannot file image file $IMAGE" 1>&2
			exit 1
		fi
	fi
	touch $IMAGE
fi


# Check for SD card to manipulate
if [ -z $DISK ]; then
	if [ $(lsblk -ln | grep disk | grep ^mmc | wc -l) -gt 1 ]; then
		echo "Multiple SD cards found, one must be specific with --dev" 1>&2
		exit 1
	elif [ $(lsblk -ln | grep disk | grep ^mmc | wc -l) -eq 1 ]; then
		DISK=/dev/$(lsblk -ln | grep disk | grep ^mmc | sed 's/ .*//')
	else
		echo "No SD card available to setup" 1>&2
		exit 1
	fi
else
	if [ ! -e $DISK ]; then
		echo "Cannot find device $DISK" 1>&2
		exit 1
	fi
fi
# Unmount all partitions on disk
i=1
while [ $i -lt 10 ]; do
	if [ -e $DISK$i ]; then
		sudo umount $DISK$i 2> /dev/null
	fi
	i=$((i + 1))
done

MNT_POINT=$(mktemp -d "/tmp/$NAME_CLI-mnt-XXXX")

# Write image or confirm SD card has raspbian
if [ "$WRITE" = "YES" ]; then
	if [ "$QUIET" = "no" ]; then
		echo "Writing image to $DISK"
	fi
	sudo dd if="$IMAGE" of="$DISK" bs=4M status=progress conv=fsync
	if [ $? -ne 0 ]; then
		echo "Error writing image to $DISK" 1>&2
		rm -rf $MNT_POINT
		exit 1
	fi
	if [ "$QUIET" = "no" ]; then
		echo "Image written to $DISK"
	fi
	sudo udevadm trigger
else
	if [ ! -e ${DISK}p2 ]; then
		echo "$DISK does not contain raspbian" 1>&2
		rm -rf $MNT_POINT
		exit 1
	fi
	sudo mount ${DISK}p2 $MNT_POINT
	if [ ! -e $MNT_POINT/usr/bin/raspi-config ]; then
		echo "$DISK does not contain raspbian" 1>&2
		sudo umount $MNT_POINT
		rm -rf $MNT_POINT
		exit 1
	fi
	sudo umount $MNT_POINT
fi


# Configuration options
USER_SETUP="no"
WIFI_SETUP="no"
SSH_SETUP="no"
if [ "$ALL" = "YES" ]; then
	USER_SETUP="YES"
	WIFI_SETUP="YES"
	SSH_SETUP="YES"
fi
if [ "$NO" = "YES" ]; then
	USER_SETUP="NO"
	WIFI_SETUP="NO"
	SSH_SETUP="NO"
fi
# Read configuration file
if [ ! -z $CONFIG ]; then
	TMP_FILE=$(mktemp "/tmp/$NAME_CLI-conf-XXXX")
	sed -e '/^[\t ]*\(#.*\|\)$/d' -e 's/\(^[\t ]*\|[\t ]*$\)//g' $CONFIG > $TMP_FILE
	if [ ! -z "$(grep -vE "^[a-zA-Z_-]+=(\".*\"|'.*')$" $TMP_FILE)" ]; then
		echo "Invalid configuration file line:" 1>&2
		echo "$(grep -vE "^[a-zA-Z_-]+=(\".*\"|'.*')$" $TMP_FILE | head -n 1)" 1>&2
		rm -rf $TMP_FILE $MNT_POINT
		exit 1
	fi
	WIFI_SSID=$(grep -E '^WIFI_SSID=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	WIFI_PASSWD=$(grep -E '^WIFI_PASSWD=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	if [ ! -z "$WIFI_SSID$WIFI_PASSWD" ]; then
		WIFI_SETUP="YES"
	fi
	# echo "WIFI_SSID='$WIFI_SSID' WIFI_PASSWD='$WIFI_PASSWD'"
	USER_ID=$(grep -E '^USER_ID=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	USER_PASSWD=$(grep -E '^USER_PASSWD=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	if [ ! -z "$USER_PASSWD" ]; then
		USER_SETUP="YES"
	fi
	rm -f $TMP_FILE
	# echo "USER_ID='$USER_ID' USER_PASSWD='$USER_PASSWD'"
fi


# Mount raspbian boot partition
if [ ! -e ${DISK}p1 ]; then
	echo "Could not find boot partition ${DISK}p1" 1>&2
	rm -rf $MNT_POINT
	exit 1
fi
sudo mount -o umask=0000 ${DISK}p1 $MNT_POINT
if [ $? -ne 0 ]; then
	echo "Could not mount ${DISK}p1" 1>&2
	rm -rf $MNT_POINT
	exit 1
fi

if [ "$USER_SETUP" = "no" ]; then
	while true; do
		read -p "Configure default user? [y/n] " c
		case $c in
			y|Y|yes) USER_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid option, please use 'y' or 'n'" ;;
		esac
	done
fi
if [ "$USER_SETUP" = "YES" ]; then
	# Setup pi user with password
	if [ -z $USER_ID ]; then
		USER_ID="pi"
	fi
	if [ -z $USER_PASSWD ]; then
		read -p "$USER_ID user password: " USER_PASSWD
	fi
	echo "pi:$(echo "$USER_PASSWD" | openssl passwd -6 -stdin)" > $MNT_POINT/userconf
	if [ "$QUIET" = "no" ]; then
		echo "User setup complete"
	fi
else
	if [ "$QUIET" = "no" ]; then
		echo "User setup skipped"
	fi
fi

if [ "$WIFI_SETUP" = "no" ]; then
	while true; do
		read -p "Configure WiFi network? [y/n] " c
		case $c in
			y|Y|yes) WIFI_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid option, please use 'y' or 'n'" ;;
		esac
	done
fi
if [ "$WIFI_SETUP" = "YES" ]; then
	echo "country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1" >> $MNT_POINT/wpa_supplicant.conf
	# Get WiFi info
	if [ -z $WIFI_SSID ]; then
		read -p "WiFi SSID: " WIFI_SSID
	fi
	if [ -z $WIFI_PSWD ]; then
		read -p "WiFi Password: " WIFI_PSWD
	fi
	# Write WiFi passphrase
	wpa_passphrase "$WIFI_SSID" "$WIFI_PSWD" >> $MNT_POINT/wpa_supplicant.conf
	if [ $? -ne 0 ]; then
		echo "WiFi Setup Failed" 1>&2
		sudo umount $MNT_POINT
		rm -rf $MNT_POINT
		exit 1
	fi
	if [ "$QUIET" = "no" ]; then
		echo "WiFi setup complete"
	fi
else
	if [ "$QUIET" = "no" ]; then
		echo "WiFi setup skipped"
	fi
fi

if [ "$SSH_SETUP" = "no" ]; then
	while true; do
		read -p "Enable SSH? [y/n] " c
		case $c in
			y|Y|yes) SSH_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid option, please use 'y' or 'n'" ;;
		esac
	done
fi
if [ "$SSH_SETUP" = "YES" ]; then
	echo "" > $MNT_POINT/ssh
	if [ "$QUIET" = "no" ]; then
		echo "SSH setup complete"
	fi
else
	if [ "$QUIET" = "no" ]; then
		echo "SSH setup skipped"
	fi
fi

sudo umount $MNT_POINT
rm -rf $MNT_POINT
exit 0
