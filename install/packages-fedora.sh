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
i3-gaps
redshift
i3status
dmenu
feh
conky
rofi
polybar
stalonetray
picom
dunst
alacritty

openvpn
python3-pip
jq
latexmk
nodejs
texlive-latex
the_silver_searcher
pamixer
rclone

gcolor3
mpd
mpv
mpc
ncmpcpp
pavucontrol
zathura-pdf-mupdf
lxappearance
google-chrome-stable

clang
ffmpeg
gnuplot
htop
neofetch
neovim
perl-Image-ExifTool
qalc
ranger
tldr
zsh
"

echo "Install Packages"
sudo dnf -y install $packages 1> /dev/null

echo "Installing Flatpaks"
sudo dnf -y install flatpak 1> /dev/null
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 1> /dev/null

sudo flatpak -y install flathub org.gimp.GIMP 1> /dev/null
sudo flatpak -y install flathub org.inkscape.Inkscape 1> /dev/null
sudo flatpak -y install flathub com.valvesoftware.Steam 1> /dev/null
sudo flatpak -y install flathub org.signal.Signal 1> /dev/null
sudo flatpak -y install flathub com.mojang.Minecraft 1> /dev/null

echo "Setting Up ZSH"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh

echo "Installing Sass"
sudo npm install -g sass > /dev/null

echo "Install Desktop Programs?"
while true; do
    read -p "[y/n]: " n
	case $n in
		y|Y) sudo dnf -y install transmission-daemon transmission-remote-gtk 1> /dev/null 
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
