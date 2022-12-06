#!/bin/sh
# Sway Debian Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v apt-get)" ]; then
	printf "\033[1;31m%s\033[0m\n" "APT not installed"
	exit 1
fi

packages="
bc
gammastep
sway
swaybg
swayidle
swaylock
waybar
wofi
"
printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Install Packages"
sudo apt -y install $packages


printf "\033[1;32m%s\033[0m\n" "[Sway Debian] Installing alacritty (from cargo)"
if [ -z $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. $HOME/.cargo/env
sudo apt-get -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cargo install alacritty --locked --bins
