#!/bin/sh
# PROGRAM INSTALLS

echo "Updating"
sudo dnf -y upgrade 1> /dev/null

echo "Enabling RPM Fusion"
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 1> /dev/null

echo "Enabling copr Repositories"
sudo dnf -y copr enable opuk/pamixer 1> /dev/null
sudo dnf -y copr enable yaroslav/i3desktop 1> /dev/null
sudo dnf -y copr enable pschyska/alacritty 1> /dev/null
#sudo dnf -y copr enable skidnik/termite 1> /dev/null

echo "Enabling Google Chrome"
sudo dnf -y install fedora-workstation-repositories 1> /dev/null
sudo dnf config-manager --set-enabled google-chrome 1> /dev/null

packages="
alacritty
clang
conky
dmenu
dunst
feh
ffmpeg
gcolor3
gnuplot
google-chrome-stable
htop
i3-gaps
i3status
jq
latexmk
lxappearance
mpc
mpd
mpv
ncmpcpp
neofetch
neovim
nethogs
nodejs
openvpn
pamixer
pavucontrol
perl-Image-ExifTool
picom
polybar
python3-pip
qalc
ranger
rclone
redshift
rofi
stalonetray
texlive-latex
the_silver_searcher
tldr
zathura-pdf-mupdf
zsh
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
"
sudo dnf -y install flatpak 1> /dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 1> /dev/null
sudo flatpak -y install flathub $flatpaks 1> /dev/null

echo "Setting Up ZSH"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh

echo "Installing Sass"
sudo npm install -g sass > /dev/null

echo "Install Desktop Programs?"
desktop="
transmission-daemon
transmission-remote-gtk
fahclient
"
while true; do
    read -p "[y/n]: " n
	case $n in
		y|Y) sudo dnf -y install $desktop 1> /dev/null 
			break;;
		n|N) break;;
		*) echo "Please enter 'y' or 'n'";;
	esac
done


#kdeconnect
#scrot
#ttf-joypixels

#android-file-transfer
#android-tools
#jpegexiforient
#matcha-gtk-theme
#papirus-maia-icon-theme
