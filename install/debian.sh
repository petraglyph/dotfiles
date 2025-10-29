#!/bin/sh
# General Debian Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
BACKPORTS_LIST="/etc/apt/sources.list.d/backports.list"
REPO_KINDS="main contrib non-free non-free-firmware"

codename="$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d'=' -f 2)"

if [ -z "$codename" ]; then
	printf "\033[1;31m%s\033[0m\n" "VERSION_CODENAME missing"
	exit 1
fi

if [ ! -f "$BACKPORTS_LIST" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Debian] Enable backports"
	echo "deb http://deb.debian.org/debian $codename-backports $REPO_KINDS
deb-src http://deb.debian.org/debian $codename-backports $REPO_KINDS" | sudo tee "$BACKPORTS_LIST" > /dev/null
fi

packages="
apt-config-auto-update
"

# Install packages
if [ "$1" = "extra" ]; then
	$(dirname $0)/apt-extra.sh $packages
else
	$(dirname $0)/apt.sh $packages
fi
