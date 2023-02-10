#!/bin/sh
#   Install and Setup Folding@Home
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
TMP_DIR=$(mktemp -d)

if [ -e /sr/bin/FAHClient ]; then
	echo "Folding@Home already installed"
	rm -rf $TMP_DIR
	exit
fi

downpkg () {
	echo "Downloading $(basename $1)"
	curl --progress-bar "$1" --output "$2"
	if [ ! -f "$2" ]; then
		echo "Download failed"
		rm -rf $TMP_DIR
		exit 1
	fi
}

echo "Installing Folding@Home"
if [ $(command -v rpm) ]; then
	PKG_URL="https://download.foldingathome.org/releases/public/release/fahclient/centos-6.7-64bit/v7.6/fahclient-7.6.21-1.x86_64.rpm"
	downpkg "$PKG_URL" "$TMP_DIR/$(basename $PKG_URL)"
	if [ $? -ne 0 ]; then
		exit 1
	fi
	sudo rpm -i $TMP_DIR/$(basename $PKG_URL)
elif [ $(command -v dpkg) ]; then
	PKG_URL="https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb"
	downpkg "$PKG_URL" "$TMP_DIR/$(basename $PKG_URL)"
	if [ $? -ne 0 ]; then
		exit 1
	fi
	exit
	echo fahclient fahclient/passkey string PASSWORD | debconf-set-selections
	echo fahclient fahclient/autostart string true | sudo debconf-set-selections
	echo fahclient fahclient/power string light | sudo debconf-set-selections
	echo fahclient fahclient/user string pennbauman | sudo debconf-set-selections
	echo fahclient fahclient/team string 260355 | sudo debconf-set-selections
	sudo dpkg -i --force-depends $TMP_DIR/$(basename $PKG_URL)
else
	error "Could not find supported package manager to install folding@home"
	rm -rf $TMP_DIR
	exit 1
fi

SYS_CONF="/etc/fahclient/config.xml"
NEW_CONF="$(dirname $(readlink -f $0))/config.xml"
if [ ! -z "$(grep "pennbauman" $SYS_CONF)" ]; then
	echo "Folding@Home already configured"
else
	if [ -e $NEW_CONF ]; then
		if [ -f $SYS_CONF ]; then
			sudo mv $SYS_CONF $SYS_CONF.orig
		fi
		sudo cp $NEW_CONF $SYS_CONF.dotfiles
		sudo cp $NEW_CONF $SYS_CONF
		echo "Folding@Home configured"
	else
		echo "$NEW_CONF missing"
		exit 1
	fi
fi

sudo /etc/init.d/FAHClient start
rm -rf $TMP_DIR
