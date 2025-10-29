#!/bin/sh
# Sway Debian Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

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
imv
libnotify-bin
mako-notifier
mpc
mpd
mpv
ncmpcpp
ncmpcpp
podman-toolbox
pulseaudio-utils
qalc
sway
swaybg
swayidle
swaylock
waybar
wildmidi
wireplumber
wofi
xwayland
zathura
"
printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Install Packages"
sudo apt-get -y install $packages $@

printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Removing Packages"
sudo apt-get -y remove xdg-desktop-portal-gtk
