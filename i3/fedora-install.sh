#!/bin/sh
# i3 Fedora Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

message "Enabling copr Repositories"
copr() {
	result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
	if [ "$result" != "Bugzilla. In case of problems, contact the owner of this repository." ]; then
		echo $result
	fi
}
copr sentry/i3desktop


packages="
alacritty
conky
dmenu
dunst
feh
i3-gaps
i3lock-color
i3status
lxappearance
picom
polybar
redshift
rofi
scrot
stalonetray
xset
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken


message "Installing xidlehook (from cargo)"
sudo dnf -y install libX11-devel
if [ -z $HOME/.cargo/env ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. $HOME/.cargo/env
cargo install xidlehook --locked --bins
