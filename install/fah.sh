#!/bin/sh
# Install and setup folding@home

loc="$HOME/.dotfiles"

# Check install location
source "$(dirname $BASH_SOURCE)/check.sh" "none"

message "Installing Folding@Home"
if [ $(command -v rpm) ]; then
	if [ ! -f $loc/.local/fahclient-7.6.13-1.x86_64.rpm ]; then
		curl https://download.foldingathome.org/releases/public/release/fahclient/centos-6.7-64bit/v7.6/fahclient-7.6.13-1.x86_64.rpm -o $loc/.local/fahclient-7.6.13-1.x86_64.rpm
	fi
	sudo rpm -i $loc/.local/fahclient-7.6.13-1.x86_64.rpm
elif [ $(command -v apt) ]; then
	if [ ! -f $loc/.local/fahclient_7.6.13_amd64.deb ]; then
		curl https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.13_amd64.deb -o $loc/.local/fahclient_7.6.13_amd64.deb
	fi
	sudo dpkg -i --force-depends $loc/.local/fahclient_7.6.13_amd64.deb
else
	error "Could not find package manager to install folding@home"
	exit 1
fi

sudo rm -rf /etc/fahclient/config.xml
if [ -f $HOME/documents/other/linux/backups/fah-config.xml ]; then
	sudo cp $HOME/documents/other/linux/backups/fah-config.xml /etc/fahclient/config.xml
else
	sudo cp $loc/configs/fah-config.xml /etc/fahclient/config.xml
fi
