#!/bin/sh

packages="
curl
feh
gcc
git
nodejs
npm
qalc
"
sudo apt update
sudo apt -y install $packages
