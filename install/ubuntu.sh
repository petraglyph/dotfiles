#!/bin/sh
# General Ubuntu Installs

sudo apt update 1> /dev/null

packages="
curl
feh
gcc
git
nodejs
npm
qalc
"
echo "Installing Packages"
sudo apt -y install $packages 1> /dev/null

echo "Setting Up ZSH"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh

echo "Installing Sass (from npm)"
sudo npm install -g sass &> /dev/null
