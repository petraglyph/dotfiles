#!/bin/sh
# i3 Fedora Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
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
copr pennbauman/ports


packages="
alacritty
conky
distrobox
dmenu
dunst
feh
flatpak
i3
i3lock-color
i3status
lxappearance
mpc
mpd
ncmpcpp
pavucontrol
picom
polybar
redshift
rofi
scrot
stalonetray
xidlehook
xset
zathura
"
printf "\033[1;32m%s\033[0m\n" "[i3 Fedora] Installing Packages"
sudo dnf -y install $packages --skip-broken --setopt=install_weak_deps=False
