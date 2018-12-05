#/bin/sh
# bash ~/.i3/scripts/install.sh

# REMOVE EXISTING CONFIGS
rm ~/.config/rofi/config
rm ~/.config/twmn/twmn.conf
rm ~/.config/polybar/config
rm ~/.config/termite/config
rm ~/.xsession
sudo rm /bin/i3locker.sh
sudo rm /etc/X11/xorg.conf.d
#sudo rm /bin/polybar-start.sh
echo "Configs Cleared"
# LINK NEW CONFIGS
ln ~/.i3/rofi-config ~/.config/rofi/config
ln ~/.i3/twmn.conf ~/.config/twmn/twmn.conf
ln ~/.i3/polybar ~/.config/polybar/config
ln ~/.i3/termite-config ~/.config/termite/config
cp ~/.i3/xsession ~/.xsession
sudo ln ~/.i3/scripts/i3locker.sh /bin/
sudo ln -r -s ~/.i3/xorg.conf.d /etc/X11/
#sudo ln ~/.i3/polybar-start.sh /bin/
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
