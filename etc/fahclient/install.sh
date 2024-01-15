#!/bin/sh
#   Install and Setup Folding@Home
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
BASE_URL="https://download.foldingathome.org/releases/public/release/fahclient"
DEB_URL="$BASE_URL/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb"
RPM_URL="$BASE_URL/centos-6.7-64bit/v7.6/fahclient-7.6.21-1.x86_64.rpm"

if [ -e /usr/bin/FAHClient ]; then
	echo "Folding@Home already installed"
	exit
fi

echo "Installing Folding@Home"
if [ ! -z "$(command -v dnf)" ]; then
	echo "Downloading $(basename $RPM_URL)"
	curl --progress-bar $RPM_URL --output /tmp/$(basename $RPM_URL)
	if [ ! -f /tmp/$(basename $RPM_URL) ]; then
		echo "Download failed"
		exit 1
	fi

	sudo rpm -i /tmp/$(basename $RPM_URL)
	rm -f /tmp/$(basename $RPM_URL)

	SYS_CONF="/etc/fahclient/config.xml"
	NEW_CONF="$(dirname $(realpath $0))/config.xml"
	if [ ! -z "$(grep "pennbauman" $SYS_CONF)" ]; then
		echo "Folding@Home already configured"
	else
		if [ -e $NEW_CONF ]; then
			if [ -f $SYS_CONF ]; then
				sudo mv $SYS_CONF $SYS_CONF.orig
			fi
			sudo cp $NEW_CONF $SYS_CONF
			echo "Folding@Home configured"
		else
			echo "$NEW_CONF missing"
			exit 1
		fi
	fi
elif [ ! -z "$(command -v apt-get)" ]; then
	echo "Downloading $(basename $DEB_URL)"
	curl --progress-bar $DEB_URL --output /tmp/$(basename $DEB_URL)
	if [ ! -f /tmp/$(basename $DEB_URL) ]; then
		echo "Download failed"
		exit 1
	fi

	read -p "Account password: " password
	echo fahclient fahclient/autostart string true | sudo debconf-set-selections
	echo fahclient fahclient/power string light | sudo debconf-set-selections
	echo fahclient fahclient/user string pennbauman | sudo debconf-set-selections
	echo fahclient fahclient/team string 260355 | sudo debconf-set-selections
	echo fahclient fahclient/passkey string $password | sudo debconf-set-selections

	sudo apt-get -y install /tmp/$(basename $DEB_URL)
	rm -f /tmp/$(basename $DEB_URL)
else
	error "Could not find supported package manager to install folding@home"
	exit 1
fi

echo "Starting Folding@Home"
sudo /etc/init.d/FAHClient start
