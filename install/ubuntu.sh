#!/bin/bash
# General Ubuntu Installs

message() {
	echo -e "\033[1;32m$1\033[0m"
}

sudo apt update

packages="
curl
feh
gcc
git
mpd
ncmpcpp
nodejs
npm
qalc
zsh
"
message "Installing Packages"
sudo apt -y install $packages

message "Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb

message "Enabling Flatpak"

message "Installing Flatpaks"
flatpaks="
org.gimp.GIMP
org.inkscape.Inkscape
com.valvesoftware.Steam
org.signal.Signal
com.mojang.Minecraft
com.discordapp.Discord
"
sudo apt -y install flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak -y install flathub $flatpaks

message "Installing Sass (from npm)"
sudo npm install -g npm
sudo npm install -g sass

message "Installing Rust (with rustup)"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
