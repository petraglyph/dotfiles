#!/bin/sh
# General Fedora Installs
#   Penn Bauman <me@pennbauman.com>

message() {
	if [ -z $BASH_SOURCE ]; then
		echo "\033[1;32m$1\033[0m"
	else
		echo -e "\033[1;32m$1\033[0m"
	fi
}

message "Configure DNF"
echo "max_parallel_downloads=8" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf


message "Updating"
sudo dnf -y upgrade

message "Enabling RPM Fusion"
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

packages="
android-tools
clang
cronie
ffmpeg
gnuplot
htop
jq
latexmk
neofetch
neovim
nethogs
nodejs
openvpn
perl-Image-ExifTool
python3-pip
qalc
ranger
rclone
sassc
texlive-latex
texlive-scheme-medium
tldr
util-linux-user
zathura
zathura-plugins-all
zathura-zsh-completion
zsh
"
if [ $# -ne 0 ]; then
	packages="$packages $@"
fi
message "Installing Packages"
sudo dnf -y install $packages --skip-broken
