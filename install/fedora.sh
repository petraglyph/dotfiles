#!/bin/sh
# General Fedora Installs

loc="$HOME/.dotfiles"
comp=$1

echo "Updating"
sudo dnf -y upgrade 1> /dev/null

echo "Enabling RPM Fusion"
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 1> /dev/null

echo "Enabling Google Chrome"
sudo dnf -y install fedora-workstation-repositories 1> /dev/null
sudo dnf config-manager --set-enabled google-chrome 1> /dev/null

packages="
kdeconnectd
rclone
$(cat "$loc/install/fedora-packages.txt")
$(cat "$loc/$comp/fedora-packages.txt")
"
echo "Install Packages"
sudo dnf -y install $packages 1> /dev/null


echo "Installing Flatpaks"
flatpaks="
org.gimp.GIMP
org.inkscape.Inkscape
com.valvesoftware.Steam
org.signal.Signal
com.mojang.Minecraft
com.discordapp.Discord
"
sudo dnf -y install flatpak 1> /dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 1> /dev/null
sudo flatpak -y install flathub $flatpaks 1> /dev/null


echo "Installing Sass (from npm)"
sudo npm install -g sass &> /dev/null
