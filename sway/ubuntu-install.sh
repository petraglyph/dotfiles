#!/bin/sh
# Sway Ubuntu Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"

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
