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
nodejs
npm
qalc
"
message "Installing Packages"
sudo apt -y install $packages

message "Setting Up ZSH"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh

message "Installing Sass (from npm)"
sudo npm install -g npm
sudo npm install -g sass
