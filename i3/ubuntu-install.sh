#!/bin/sh
# i3 Fedora Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"


# alacritty
sudo add-apt-repository -y ppa:aslatter/ppa
# i3-gaps picom polybar
sudo add-apt-repository -y ppa:kgilmer/speed-ricer
sudo apt update

#Getting required Perl version"
sudo dnf module reset perl
sudo dnf module install perl:5.30 --allowerasing

packages="
alacritty
conky
dunst
feh
i3-gaps
lxappearance
picom
polybar
redshift
rofi
scrot
stalonetray
suckless-tools
"
#i3status
message "Install Packages"
sudo apt -y install $packages


message "Builds From Source"
mkdir -p "$loc/.local"

message "  i3lock-color"
sudo apt -y install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev
cd "$loc/.local"
if [ -e i3lock-color ]; then
	cd i3lock-color
	git pull
else
	git clone https://github.com/Raymo111/i3lock-color.git
	cd i3lock-color
fi
./install-i3lock-color.sh

message "  xidlehook"
sudo apt -y install cargo libx11-xcb-dev libxcb-screensaver0-dev
cargo install xidlehook --locked --bins

message "  pamixer"
sudo apt -y install libpulse-dev libboost-program-options-dev
cd "$loc/.local"
if [ -e pamixer ]; then
	cd pamixer
	git pull
else
	git clone https://github.com/cdemoulins/pamixer.git
	cd pamixer
fi
make && sudo cp pamixer /bin
