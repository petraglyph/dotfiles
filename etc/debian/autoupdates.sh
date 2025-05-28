#!/bin/sh
# Enable Debian Auto Updates
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

packages="
apt-config-auto-update
apt-listchanges
powermgmt-base
unattended-upgrades
"

printf "\033[1;32m%s\033[0m\n" "[APT] Enabling Auto Updates"
sudo apt-get update
sudo apt-get -y install $packages
