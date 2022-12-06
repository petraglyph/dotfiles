#!/bin/sh
# General Ubuntu Installs
#   Penn Bauman <me@pennbauman.com>


printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Remove Ubuntu Advantage"
sudo apt-get -y install ubuntu-release-upgrader-core
sudo apt-get -y remove ubuntu-advantage-tools ubuntu-advantage-desktop-daemon

printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Disable snapd"
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null

printf "\033[1;32m%s\033[0m\n" "[Ubuntu] Adding Neovim Stable PPA"
sudo add-apt-repository -y ppa:neovim-ppa/stable


$(dirname $0)/apt.sh
