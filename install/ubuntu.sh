#!/bin/sh
# General Ubuntu Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles


printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Disable snapd"
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null

printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Adding distrobox PPA"
sudo add-apt-repository -y ppa:michel-slm/distrobox

$(dirname $0)/apt.sh distrobox ubuntu-release-upgrader-core

printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Remove Ubuntu Advantage"
sudo apt-get -y remove ubuntu-advantage-tools ubuntu-advantage-desktop-daemon

if [ "$(findmnt -no FSTYPE /)" = "btrfs" ]; then
	printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Add APT Btrfs snapshots"
	sudo apt-get -y install apt-btrfs-snapper
fi
