#!/bin/sh
# Setup Raspbian Image and/or Write to SD Card
#   Penn Bauman <me@pennbauman.com>
CACHE_DIR="$HOME/.cache/raspbian"
MNT_POINT=$(mktemp -d)
TMP_FILE=$(mktemp)
HELP_TEXT="Raspbian Image Setup Script

  $ $(basename $0) <options...>

Options:
  --help, -h           Print this help message
  --write, -w          Write Raspbian image to SD card before setup
  --dev [path]         Device to write image onto
  --autodownload, -d   Automatically download a Raspbian image in necessary
  --image, -i [file]   Specify local Raspbian image to write
  --all, -a            Preform all manual configurations
  --no, -n             Do not ask to preform manual configurations
  --config, -c [file]  Configuration file to autofill settings

Configuration File Settings:
  USER_ID=\"username\"        Default user on system
  USER_PASSWD=\"password\"    Password for default user
  WIFI_SSID=\"name\"          WiFi network name
  WIFI_PASSWD=\"password\"    WiFi network password
"


# Check required commands are available
for cmd in openssl wpa_passphrase wget xz; do
	if [ -z $(command -v $cmd) ]; then
		echo "! Missing dependency $cmd"
		exit 1
	fi
done


# Options
WRITE="no"
DISK=""
AUTODOWNLOAD="no"
IMAGE=""
ALL="no"
NO="no"
CONFIG=""

# Read command line options
if [ $# -gt 0 ]; then
	GET_VALUE=""
	for arg in "$@"; do
		if [ ! -z $GET_VALUE ]; then
			case $GET_VALUE in
				--image|-i) IMAGE="$arg" ;;
				--dev) DISK="$arg" ;;
				--config|-c) CONFIG="$arg" ;;
				*) echo "UNREACHABLE CODE ($$GET_VALUE case)"; exit 1 ;;
			esac
			GET_VALUE=""
			continue
		fi
		#echo "arg: '$arg'"
		if [ ! -z $(echo $arg | grep -oE '^-*[hH](elp|)$') ]; then
			echo "$HELP_TEXT"
			exit 0
		fi

		case $arg in
			--write|-w) WRITE="YES" ;;
			--dev) GET_VALUE="$arg" ;;
			--autodownload|-d) AUTODOWNLOAD="YES" ;;
			--image|-i) GET_VALUE="$arg" ;;
			--all|-a) ALL="YES" ;;
			--no|-n) NO="YES" ;;
			--config|-c) GET_VALUE="$arg" ;;
			*) echo "! Unknown arguement '$arg'"
				exit 1 ;;
		esac
	done
	# Check if value for option is still required
	case $GET_VALUE in
		"" ) ;;
		--image|-i) echo "! Missing image file for '$GET_VALUE' option" ; exit 1 ;;
		--dev) echo "! Missing path file for '$GET_VALUE' option" ; exit 1 ;;
		--config|-c) echo "! Missing config file for '$GET_VALUE' option" ; exit 1 ;;
		*) echo "UNREACHABLE CODE ($$GET_VALUE case)"; exit 1 ;;
	esac
fi
if [ "$ALL" = "YES" ] && [ "$NO" = "YES" ]; then
	echo "! Cannot specify both --all and --no, they conflict"
	exit 1
fi

# Check for image to write, autodownload if necessary
if [ "$WRITE" = "YES" ]; then
	if [ -z "$IMAGE" ]; then
		# Default image from https://www.raspberrypi.com/software/operating-systems
		img_url="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-07/2022-09-06-raspios-bullseye-armhf-lite.img.xz"
		compressed_img="$CACHE_DIR/$(basename $img_url)"
		IMAGE=$(echo $compressed_img | sed 's/\.xz$//')

		# Download image if necessary
		if [ ! -f $IMAGE ]; then
			echo down
			if [ ! "$AUTODOWNLOAD" = "YES" ]; then
				echo "No image provided for writing to SD card"
				echo "Images can be provided with --image option"
				question="Would you like to download one? [y/n] "
				while true; do
					read -p "$question" c
					case $c in
						y|Y|yes) break ;;
						n|N|no) echo "! No image available to write"
							exit 0 ;;
						*) echo "  Invalid input, please use 'y' or 'n'" ;;
					esac
					question="Download? [y/n] "
				done
			fi
			echo "> Downloading Raspbian image"

			mkdir -p $CACHE_DIR
			wget -q --show-progress $img_url -O $compressed_img
			if [ $? -ne 0 ]; then
				rm -f $compressed_img
				echo "! Error downloading $img_url"
				exit 1
			fi
			xz -dv $compressed_img
			if [ $? -eq 0 ]; then
				rm -f $compressed_img
			else
				rm -f $IMAGE
				echo "! Error decompressing ~${compressed_img#$HOME}"
				exit 1
			fi
			echo
			echo "> Image downloaded ~${IMAGE#$HOME}"
		else
			echo "> Image found at ~${IMAGE#$HOME}"
		fi
	else
		if [ ! -f "$IMAGE" ]; then
			echo "! Cannot file image file $IMAGE"
			exit 1
		fi
	fi
	touch $IMAGE
fi
#echo "image: $IMAGE"


# Check for SD card to manipulate
if [ -z $DISK ]; then
	if [ $(lsblk -ln | grep disk | grep ^mmc | wc -l) -gt 1 ]; then
		echo "! Multiple SD cards found, one must be specific with --dev"
		exit 1
	elif [ $(lsblk -ln | grep disk | grep ^mmc | wc -l) -eq 1 ]; then
		DISK=/dev/$(lsblk -ln | grep disk | grep ^mmc | sed 's/ .*//')
	else
		echo "! No SD card available to setup"
		exit 1
	fi
else
	if [ ! -e $DISK ]; then
		echo "! Cannot file device $DISK"
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
#echo "disk: $DISK"


# Write image or confirm SD card has raspbian
if [ "$WRITE" = "YES" ]; then
	echo "> Writing image to SD Card"
	sudo dd if="$IMAGE" of="$DISK" bs=4M status=progress conv=fsync
	if [ $? -ne 0 ]; then
		echo "! Error writing image to $DISK"
		exit 1
	fi
	echo "> Image written to SD CARD"
else
	if [ ! -e ${DISK}p2 ]; then
		echo "! SD card does not contain raspbian"
		exit 1
	fi
	sudo mount ${DISK}p2 $MNT_POINT
	if [ ! $(grep -E '^ID=' $MNT_POINT/etc/os-release | sed 's/ID=//') = "raspbian" ]; then
		echo "! SD card does not contain raspbian"
		sudo umount $MNT_POINT
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
	sed -e '/^[\t ]*\(#.*\|\)$/d' -e 's/\(^[\t ]*\|[\t ]*$\)//g' $CONFIG > $TMP_FILE
	if [ ! -z "$(grep -vE "^[a-zA-Z_-]+=(\".*\"|'.*')$" $TMP_FILE)" ]; then
		echo "! Invalid configuration file line:"
		echo "$(grep -vE "^[a-zA-Z_-]+=(\".*\"|'.*')$" $TMP_FILE | head -n 1)"
		exit 1
	fi
	WIFI_SSID=$(grep -E '^WIFI_SSID=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	WIFI_PASSWD=$(grep -E '^WIFI_PASSWD=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	if [ ! -z $WIFI_SSID$WIFI_PASSWD ]; then
		WIFI_SETUP="YES"
	fi
	echo "WIFI_SSID='$WIFI_SSID' WIFI_PASSWD='$WIFI_PASSWD'"
	USER_ID=$(grep -E '^USER_ID=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	USER_PASSWD=$(grep -E '^USER_PASSWD=' $TMP_FILE | sed -e "s/\(^[A-Z_]*=['\"]\|['\"]$\)//g")
	if [ ! -z $USER_PASSWD ]; then
		USER_SETUP="YES"
	fi
	echo "USER_ID='$USER_ID' USER_PASSWD='$USER_PASSWD'"
fi
#echo "USER_SETUP='$USER_SETUP' WIFI_SETUP='$WIFI_SETUP' SSH_SETUP='$SSH_SETUP'"


# Mount raspbian boot partition
if [ ! -e ${DISK}p1 ]; then
	echo "! Could not find boot partition ${DISK}p1"
	exit 1
fi
sudo mount -o umask=0000 ${DISK}p1 $MNT_POINT
if [ $? -ne 0 ]; then
	echo "! Could not mount ${DISK}p1"
	exit 1
fi

if [ "$USER_SETUP" = "no" ]; then
	while true; do
		read -p "Configure default user? [y/n] " c
		case $c in
			y|Y|yes) USER_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid input, please use 'y' or 'n'" ;;
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
	echo "> User setup complete"
else
	echo "> User setup skipped"
fi

if [ "$WIFI_SETUP" = "no" ]; then
	while true; do
		read -p "Configure WiFi network? [y/n] " c
		case $c in
			y|Y|yes) WIFI_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid input, please use 'y' or 'n'" ;;
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
		echo "! Wifi Setup Failed"
		sudo umount $MNT_POINT
		exit 1
	fi
	echo "> WiFi setup complete"
else
	echo "> WiFi setup skipped"
fi

if [ "$SSH_SETUP" = "no" ]; then
	while true; do
		read -p "Enable SSH? [y/n] " c
		case $c in
			y|Y|yes) SSH_SETUP="YES" ; break ;;
			n|N|no) break ;;
			*) echo "  Invalid input, please use 'y' or 'n'" ;;
		esac
	done
fi
if [ "$SSH_SETUP" = "YES" ]; then
	echo "" > $MNT_POINT/ssh
	echo "> SSH setup complete"
else
	echo "> SSH setup skipped"
fi

sudo umount $MNT_POINT
rm -rf $MNT_POINT
exit 0
