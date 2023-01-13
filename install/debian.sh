#!/bin/sh
# General Debian Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

. /etc/os-release

if [ -z "$VERSION_CODENAME" ]; then
	printf "\033[1;31m%s\033[0m\n" "\$VERSION_CODENAME missing"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[Debian] Enable backports"
echo "deb http://deb.debian.org/debian $VERSION_CODENAME-backports main" | sudo tee /etc/apt/sources.list.d/backports.list


$(dirname $0)/apt.sh
