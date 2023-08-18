#!/bin/sh
# Sway Debian Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

packages="
alacritty
at-spi2-core
bc
bluez
flatpak
gammastep
grim
mako-notifier
mpc
mpd
mpv
ncmpcpp
ncmpcpp
podman-toolbox
pulseaudio-utils
sway
swaybg
swayidle
swaylock
waybar
wildmidi
wireplumber
wofi
zathura
"
printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Install Packages"
sudo apt-get -y install $packages

printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Removing Packages"
sudo apt-get -y remove xdg-desktop-portal-gtk
