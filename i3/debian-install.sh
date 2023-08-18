#!/bin/sh
# i3 Debian Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

packages="
alacritty
bluez
conky
dunst
feh
flatpak
i3-wm
mpc
mpd
mpv
ncmpcpp
ncmpcpp
pavucontrol
picom
podman-toolbox
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
zathura
zathura
"
printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Install Packages"
sudo apt-get -y install $packages


printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Installing i3lock-color (from source)"
sudo apt-get -y install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
mkdir -p "$HOME/.cache/dotfiles"
BUILD_ROOT="$HOME/.cache/dotfiles/i3lock-color"
if [ -d $BUILD_ROOT ]; then
	git -C $BUILD_ROOT pull --ff-only
else
	rm -rf $BUILD_ROOT
	git clone https://github.com/Raymo111/i3lock-color.git $BUILD_ROOT
fi
cd $BUILD_ROOT && $BUILD_ROOT/install-i3lock-color.sh

if [ ! -f $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. $HOME/.cargo/env

printf "\033[1;32m%s\033[0m\n" "[i3 Debian] Installing xidlehook (from cargo)"
sudo apt-get -y install libx11-xcb-dev libxcb-screensaver0-dev
cargo install xidlehook --locked --bins
