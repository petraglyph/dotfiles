#!/bin/sh
# General Fedora Installs
#   Penn Bauman <me@pennbauman.com>

if [ ! -z "$(command -v rpm-ostree)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[Fedora] OSTree packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling Copr repositories"
	curl -s "https://copr.fedorainfracloud.org/coprs/pennbauman/ports/repo/fedora-/" | sudo tee /etc/yum.repos.d/pennbauman-ports.repo > /dev/null
	curl -s "https://copr.fedorainfracloud.org/coprs/nickavem/adw-gtk3/repo/fedora-/" | sudo tee /etc/yum.repos.d/nickavem-adw-gtk3.repo > /dev/null

	$(dirname $0)/rpm-ostree.sh
elif [ ! -z "$(command -v dnf)" ]; then
	printf "\033[1;34m%s\033[0m\n" "[Fedora] Traditional packaging detected"

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Configure DNF"
	if [ ! -f /etc/dnf/dnf.conf ]; then
		if [ -z "$(command -v dnf)" ]; then
			printf "\033[1;31m%s\033[0m\n" "DNF not installed"
			exit 1
		fi
		echo "[main]" | sudo tee /etc/dnf/dnf.conf
	fi
	echo "max_parallel_downloads=8" | sudo tee -a /etc/dnf/dnf.conf
	echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling Copr repositories"
	sudo dnf -y copr enable nickavem/adw-gtk3
	sudo dnf -y copr enable pennbauman/ports

	printf "\033[1;32m%s\033[0m\n" "[Fedora] Enabling RPM Fusion"
	sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

	$(dirname $0)/dnf.sh
else
	printf "\033[1;31m%s\033[0m\n" "[Fedora] Package management not detected"
	exit 1
fi






