#!/bin/sh
# General Fedora Installs

message() {
	echo -e "\033[1;32m$1\033[0m"
}

loc="$(dirname $BASH_SOURCE)"

message "Updating"
sudo dnf -y upgrade

message "Enabling RPM Fusion"
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

message "Enabling Google Chrome"
sudo dnf -y install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

packages="
kdeconnectd
rclone
$(cat "$loc/fedora-packages.txt")
"
if (( $# > 0 )); then
	packages="$packages
	$(cat "$1")"
fi
message "Installing Packages"
sudo dnf -y install $packages


message "Installing Flatpaks"
flatpaks="
org.gimp.GIMP
org.inkscape.Inkscape
com.valvesoftware.Steam
org.signal.Signal
com.mojang.Minecraft
com.discordapp.Discord
"
sudo dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y install flathub $flatpaks


message "Installing Sass (from npm)"
sudo npm install -g npm
sudo npm install -g sass
