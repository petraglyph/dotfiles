#!/bin/sh
# PROGRAM INSTALLS
pgms="
bluez
bluez-utils
conky
dunst
firefox
hunspell-en_US
i3-gaps
i3exit
i3lock-color
jq
kdeconnect
libqalculate
ly
mpc
mpd
mpv
ncmpcpp
networkmanager
npm
pamixer
pcloud-drive
picom
polybar
ranger
redshift
rofi
scrot
stalonetray
termite
tldr
ttf-joypixels
neovim
xidlehook
xorg-xbacklight
zsh


android-file-transfer
android-tools
bash-language-server
bumblebee
conky
feh
ffmpeg
gcolor3
gnome-disk-utility
gnuplot
gotop
htop
jpegexiforient
lxappearance-gtk3
matcha-gtk-theme
neofetch
openvpn
papirus-maia-icon-theme
pavucontrol
perl-image-exiftool
playerctl
python-pip
rhythmbox
the_silver_searcher
transmission-cli
transmission-remote-gtk
zathura-pdf-mupdf


clang
doxygen
intellij-idea-community-edition-no-jre
latex-mk
nasm


gimp
google-chrome
inkscape
libreoffice-fresh
minecraft-launcher
signal-desktop
steam-native
"

exec yay -S --needed $pgms
