#!/bin/sh
# General Enterprise Linux Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

printf "\033[1;32m%s\033[0m\n" "[RHEL] Configure DNF"
if [ ! -f /etc/dnf/dnf.conf ]; then
	if [ -z "$(command -v dnf)" ]; then
		printf "\033[1;31m%s\033[0m\n" "DNF not installed"
		exit 1
	fi
	echo "[main]" | sudo tee /etc/dnf/dnf.conf > /dev/null
fi
if [ -z "$(grep max_parallel_downloads /etc/dnf/dnf.conf)" ]; then
	echo "max_parallel_downloads=8" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
fi
if [ -z "$(grep fastestmirror /etc/dnf/dnf.conf)" ]; then
	echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
fi

printf "\033[1;32m%s\033[0m\n" "[RHEL] Enabling EPEL"
sudo dnf config-manager --set-enabled crb
sudo dnf install -y epel-release

printf "\033[1;32m%s\033[0m\n" "[RHEL] Enabling RPM Fusion"
sudo dnf config-manager --set-enabled crb
sudo dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

$(dirname $0)/dnf.sh
