#!/bin/sh
# General Fedora Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

copradd () {
	url="https://copr.fedorainfracloud.org/coprs/$1/$2/repo/fedora-/"
	file="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:$1:$2.repo"
	if [ ! -f "$file" ]; then
		curl -s "$url" | sudo tee "$file" > /dev/null
		if [ $? -ne 0 ]; then
			sudo rm -f "$file"
			echo "Copr add failed ($1 $2)"
		fi
	fi
}

if [ ! -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[Fedora] OSTree packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling Copr repositories"
	copradd pennbauman ports

	# Install packages
	$(dirname $0)/rpm-ostree.sh
elif [ ! -z "$(command -v dnf)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[Fedora] Traditional packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling Copr repositories"
	copradd pennbauman ports

	if [ "$1" = "extra" ]; then
		printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling RPM Fusion"
		sudo dnf5 -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	fi

	# Install packages
	if [ "$1" = "extra" ]; then
		$(dirname $0)/dnf-extra.sh
	else
		$(dirname $0)/dnf.sh
	fi
else
	printf "\033[1;31m%s\033[0m\n" "[Fedora] Package management not detected"
	exit 1
fi
