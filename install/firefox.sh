#!/bin/sh
# Install Firefox
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

os_id="$(grep '^ID=' /etc/os-release | cut -d'=' -f 2)"

if [ "$os_id" = "debian" ] || [ "$os_id" = "ubuntu" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Firefox] Installing (APT)"
	KEY_URL="https://packages.mozilla.org/apt/repo-signing-key.gpg"
	KEY_FILE="/etc/apt/keyrings/packages.mozilla.org.asc"
	SOURCE_FILE="/etc/apt/sources.list.d/mozilla.list"
	CONF_FILE="/etc/apt/preferences.d/mozilla"
	SHA512="81bde6a80b434b36c90df26de52897ad1768f4f8e9bb47d976fff1ab73033bc06fabb6398ae3e96084be6a33f4215fe7ea6d8b5b9e6402ffd1f964715657fb57"

	# Add repository signing key
	if [ ! -f $KEY_FILE ]; then
		sudo install -d -m 0755 $(dirname $KEY_FILE)
		wget -q $KEY_URL -O- | sudo tee $KEY_FILE > /dev/null
		if $(sha512sum $KEY_FILE | grep -qE "^$SHA512  $KEY_FILE$"); then
			printf "\033[1;32m%s\033[0m\n" "[Firefox] Signing key verified"
		else
			printf "\033[1;31m%s\033[0m\n" "[Firefox] Signing key hash not valid"
			exit 1
		fi
	fi

	# Configure APT
	echo "deb [signed-by=$KEY_FILE] https://packages.mozilla.org/apt mozilla main" | sudo tee $SOURCE_FILE > /dev/null
	echo "Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000" | sudo tee $CONF_FILE > /dev/null

	# Update and install firefox
	sudo apt-get update
	sudo apt-get -y install firefox
else
	echo "Unknown OS '$os_id'"
	exit 1
fi
