#!/bin/sh
# i3 Debian Installs
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

packages="
alacritty
bluez
conky-cli
dunst
feh
i3-wm
mpc
mpd
mpv
ncmpcpp
ncmpcpp
pavucontrol
picom
polybar
pulseaudio-utils
redshift
rofi
scrot
trayer
wildmidi
wireplumber
x11-xserver-utils
xinit
"
printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Install Packages"
sudo apt-get -y install $packages


printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Installing i3lock-color (from source)"
sudo apt-get -y install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev
mkdir -p "$HOME/.cache/dotfiles"
BUILD_ROOT="$HOME/.cache/dotfiles/i3lock-color"
if [ -d $BUILD_ROOT ]; then
	git -C $BUILD_ROOT pull --ff-only
else
	rm -rf $BUILD_ROOT
	git clone https://github.com/Raymo111/i3lock-color.git $BUILD_ROOT
fi
cd $BUILD_ROOT && $BUILD_ROOT/install-i3lock-color.sh

printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Installing xidlehook (from cargo)"
sudo apt-get -y install cargo libx11-xcb-dev libxcb-screensaver0-dev
sudo cargo install xidlehook --locked --bins --root /usr/local
