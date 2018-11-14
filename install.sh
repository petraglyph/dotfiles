#/bin/sh
# bash ~/.i3/install.sh

# REMOVE EXISTING CONFIGS
rm ~/.config/rofi/config
rm ~/.config/twmn/twmn.conf
sudo rm /bin/blur-i3lock.sh
sudo rm /bin/window-file-clear.sh
sudo rm /etc/X11/xorg.conf.d
echo "Configs Cleared"
# LINK NEW CONFIGS
ln ~/.i3/rofi-config ~/.config/rofi/config
ln ~/.i3/twmn.conf ~/.config/twmn/twmn.conf
sudo ln ~/.i3/blur-i3lock.sh /bin/
sudo ln ~/.i3/window-file-clear.sh /bin/
sudo ln -r -s ~/.i3/xorg.conf.d /etc/X11/
echo "Configs Linked"

# PROGRAM INSTALLS
pgms=()
pgms+=("rofi")
pgms+=("lxappearance")
pgms+=("compton")
pgms+=("feh")
pgms+=("i3blocks")
pgms+=("redshift")
pgms+=("thunar")
pgms+=("xorg-xbacklight")
pgms+=("conky")
pgms+=("gparted")
pgms+=("neofetch")

pgms+=("gimp")
#pgms+=("lollypop")
pgms+=("rhythmbox")
pgms+=("atom")

exec sudo pacman -S ${pgms[*]}
