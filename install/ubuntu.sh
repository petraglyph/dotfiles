#!/bin/sh
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

message "Installing Sass (from npm)"
sudo npm install -g npm
sudo npm install -g sass
