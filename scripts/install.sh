#/bin/sh
# bash scripts/install.sh

loc="/home/penn/.i3"

# REMOVE EXISTING CONFIGS
rm ~/.config/rofi/config
rm ~/.config/twmn/twmn.conf
rm ~/.config/termite/config
rm ~/.config/dunst/dunstrc
sudo rm /bin/i3locker.sh
sudo rm /etc/X11/xorg.conf.d
sudo rm /etc/cron.weekly/backup
sudo rm /etc/cron.daily/backup
sudo rm /usr/lib/systemd/system-sleep/pre-suspend.sh
echo "Configs Cleared"
# LINK NEW CONFIGS
ln $loc/configs/rofi-config ~/.config/rofi/config
ln $loc/configs/twmn.conf ~/.config/twmn/twmn.conf
ln $loc/configs/termite-config ~/.config/termite/config
ln $loc/configs/dunstrc ~/.config/dunst/dunstrc
sudo ln $loc/scripts/i3locker.sh /bin/
sudo ln -r -s $loc/xorg.conf.d /etc/X11/
sudo cp $loc/scripts/backup-weekly.sh /etc/cron.weekly/backup
sudo cp $loc/scripts/backup-daily.sh /etc/cron.daily/backup
sudo chmod +x /etc/cron.weekly/backup
sudo chmod +x /etc/cron.daily/backup
sudo cp $loc/scripts/pre-suspend.sh /usr/lib/systemd/system-sleep/
sudo chmod +x /usr/lib/systemd/system-sleep/pre-suspend.sh
echo "Configs Linked"

# PROGRAM INSTALLS
pgms=()
# backend
pgms+=("rofi")
pgms+=("compton")
pgms+=("feh")
pgms+=("redshift")
pgms+=("xorg-xbacklight")
pgms+=("xautolock")
pgms+=("pamixer")
pgms+=("playerctl")
pgms+=("mncli")
pgms+=("conky")
pgms+=("i3lock-color")
pgms+=("sddm")
pgms+=("sddm-maia-theme")
pgms+=("papirus-maia-icon-theme")
pgms+=("ttf-emojione-color")
pgms+=("ttf-font-awesome")
pgms+=("vimix-gtk-themes-git")
pgms+=("dunst")
# utility
pgms+=("termite")
pgms+=("lxappearance")
pgms+=("pcmanfm")
pgms+=("gparted")
pgms+=("neofetch")
pgms+=("pcloudcc")
pgms+=("kdeconnectd")
pgms+=("openvpn")
pgms+=("calc")
# applications
pgms+=("gimp")
pgms+=("transmission-gtk")
pgms+=("visual-studio-code-bin")
pgms+=("rhythmbox")

exec yay -S ${pgms[*]}
