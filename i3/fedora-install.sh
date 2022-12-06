#!/bin/sh
# i3 Fedora Installs
#   Penn Bauman <me@pennbauman.com>

if [ -z "$(command -v dnf)" ]; then
	printf "\033[1;31m%s\033[0m\n" "DNF not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[i3 Fedora] Enabling copr Repositories"
copr() {
	result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
	if [ "$result" != "Bugzilla. In case of problems, contact the owner of this repository." ]; then
		echo $result
	fi
}
copr sentry/i3desktop


packages="
mpc
mpd
ncmpcpp
alacritty
conky
dmenu
dunst
feh
i3-gaps
i3lock-color
i3status
lxappearance
pavucontrol
picom
polybar
redshift
rofi
scrot
stalonetray
xset
"
printf "\033[1;32m%s\033[0m\n" "[i3 Fedora] Installing Packages"
sudo dnf -y install $packages --skip-broken


printf "\033[1;32m%s\033[0m\n" "[i3 Fedora] Installing xidlehook (from cargo)"
sudo dnf -y install libX11-devel
if [ -z $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. $HOME/.cargo/env
cargo install xidlehook --locked --bins
