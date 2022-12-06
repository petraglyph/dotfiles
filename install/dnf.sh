#!/bin/sh
# General DNF Installs
#   Penn Bauman <me@pennbauman.com>

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
ffmpeg
flatpak
git-email
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
rclone
sassc
ssmtp
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
printf "\033[1;32m%s\033[0m\n" "[DNF] Installing Packages"
sudo dnf -y install $packages --skip-broken
