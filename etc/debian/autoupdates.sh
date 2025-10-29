#!/bin/sh
# Enable Debian Auto Updates
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

packages="
apt-config-auto-update
apt-listchanges
powermgmt-base
unattended-upgrades
"

printf "\033[1;32m%s\033[0m\n" "[APT] Enabling Auto Updates"
sudo apt-get update
sudo apt-get -y install $packages
