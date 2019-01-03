#/bin/sh
# bash ~/.i3/scripts/install.sh

# REMOVE EXISTING CONFIGS
rm ~/.config/rofi/config
rm ~/.config/twmn/twmn.conf
rm ~/.config/termite/config
rm ~/.xsession
sudo rm /bin/i3locker.sh
sudo rm /etc/X11/xorg.conf.d
sudo rm /etc/cron.weekly/backup
sudo rm /etc/cron.daily/backup
echo "Configs Cleared"
# LINK NEW CONFIGS
ln ~/.i3/configs/rofi-config ~/.config/rofi/config
ln ~/.i3/configs/twmn.conf ~/.config/twmn/twmn.conf
ln ~/.i3/configs/termite-config ~/.config/termite/config
cp ~/.i3/configs/xsession ~/.xsession
sudo ln ~/.i3/scripts/i3locker.sh /bin/
sudo ln -r -s ~/.i3/xorg.conf.d /etc/X11/
sudo cp ~/.i3/scripts/backup-weekly.sh /etc/cron.weekly/backup
sudo cp ~/.i3/scripts/backup-daily.sh /etc/cron.daily/backup
sudo chmod +x /etc/cron.weekly/backup
sudo chmod +x /etc/cron.daily/backup
echo "Configs Linked"

# PROGRAM INSTALLS
pgms=()
pgms+=("rofi")
pgms+=("lxappearance")
pgms+=("compton")
pgms+=("feh")
pgms+=("redshift")
pgms+=("xorg-xbacklight")
pgms+=("pamixer")
pgms+=("conky")

pgms+=("termite")
pgms+=("pcmanfm")
pgms+=("gparted")
pgms+=("neofetch")
pgms+=("pcloudcc")
pgms+=("kdeconnectd")

pgms+=("gimp")
pgms+=("transmission-gtk")
pgms+=("visual-studio-code-bin")
pgms+=("lollypop")
pgms+=("rhythmbox")
pgms+=("atom")

exec sudo pacman -S ${pgms[*]}
