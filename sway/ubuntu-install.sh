#!/bin/sh
# Sway Ubuntu Installs

loc="$HOME/.dotfiles"

# Check install location and comp
. "$(dirname $(readlink -f $0))/../install/check.sh" "$comp"

message "Enabling PPAs Repositories"
sudo add-apt-repository ppa:aslatter/ppa


packages="
alacritty
sway
swaybg
swayidle
swaylock
waybar
"
#gammastep
message "Install Packages"
sudo apt -y install $packages
