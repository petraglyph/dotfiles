#!/bin/sh
# PROGRAM INSTALLS
pgms="
calc
conky
dunst
firefox
i3-gaps
i3exit
i3lock-color
jq
kdeconnect
ly
mpc
mpd
mpv
ncmpcpp
networkmanager
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
ttf-material-icons
neovim
xidlehook
xorg-xbacklight
zsh


android-file-transfer
android-tools
bash-language-server
bumblebee
feh
ffmpeg
gcolor3
gnuplot
gotop
gparted
htop
jpegexiforient
lxappearance-gtk3
matcha-gtk-theme
neofetch
openvpn
papirus-maia-icon-theme
perl-image-exiftool
playerctl
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

exec yay -S $pgms
