#!/bin/sh
# i3 Fedora Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"

message "Enabling copr Repositories"
copr() {
	result=$(sudo dnf -y copr enable $1 2>&1 | tail -1)
	if [[ $result != "Bugzilla. In case of problems, contact the owner of this repository." ]]; then
		echo $result
	fi
}
copr pschyska/alacritty
copr sentry/i3desktop
#copr opuk/pamixer
#copr skidnik/termite

#Getting required Perl version"
sudo dnf module install perl:5.30 --allowerasing

packages="
alacritty
conky
dmenu
dunst
i3-gaps
i3lock-color
i3status
lxappearance
picom
polybar
rofi
scrot
stalonetray
redshift
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken


message "Builds From Source"
mkdir -p "$loc/.local"

message "  xidlehook"
sudo dnf -y install cargo libX11-devel
cargo install xidlehook

message "  xidlehook"
sudo dnf -y install boost-devel pulseaudio-libs-devel
cd "$loc/.local"
if [ -e pamixer ]; then
	cd pamixer
	git pull
else
	git clone https://github.com/cdemoulins/pamixer.git
	cd pamixer
fi
make && sudo cp pamixer /bin
