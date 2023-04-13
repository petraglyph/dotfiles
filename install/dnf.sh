#!/bin/sh
# General DNF Installs
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ -z "$(command -v dnf)" ]; then
	printf "\033[1;31m%s\033[0m\n" "DNF not installed"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[DNF] Updating"
sudo dnf -y upgrade

packages="
android-tools
clang
cronie
dash
distrobox
ffmpeg
flatpak
git-email
gnuplot
htop
jq
lf
lf-zsh-integration
neofetch
neovim
nethogs
nodejs
openvpn
perl-Image-ExifTool
python3-pip
qalc
rclone
sassc
sqlite
ssmtp
steam-devices
tldr
util-linux-user
zathura
zathura-plugins-all
zathura-zsh-completion
zellij
zsh
"
printf "\033[1;32m%s\033[0m\n" "[DNF] Installing Packages"
sudo dnf -y install --skip-broken $packages $@
