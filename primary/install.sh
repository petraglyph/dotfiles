#/bin/sh
# bash scripts/install.sh [quick]

loc="/home/penn/Storage/Linux/i3-config"

# REMOVE EXISTING CONFIGS
rm $HOME/.config/i3/config
rm $HOME/.config/rofi/config
rm $HOME/.config/termite/config
rm $HOME/.config/dunst/dunstrc
rm $HOME/.config/mc/mc.keymap
rm $HOME/.config/ncmpcpp/config
rm $HOME/.config/polybar/config
rm $HOME/.config/i3blocks/config
rm $HOME/.config/polybar/polybar-net-conky
rm $HOME/.config/polybar/polybar-net-conky-short
rm $HOME/.config//polybarvolume.sh
sudo rm /etc/X11/xorg.conf.d
sudo rm /etc/cron.weekly/backup
sudo rm /etc/cron.daily/backup
sudo rm /usr/lib/systemd/system-sleep/pre-suspend.sh
sudo rm /usr/share/mc/skins/mc-custom.ini
echo "Configs Cleared"
# LINK NEW CONFIGS
ln -s $loc/primary/config $HOME/.config/i3/config
ln -s $loc/configs/rofi-config $HOME/.config/rofi/config
ln -s $loc/configs/termite-config $HOME/.config/termite/config
ln -s $loc/configs/dunstrc $HOME/.config/dunst/dunstrc
ln -s $loc/configs/mc.keymap $HOME/.config/mc/mc.keymap
ln -s $loc/configs/ncmpcpp-config $HOME/.config/ncmpcpp/config
ln -s $loc/configs/polybar $HOME/.config/polybar/config
ln -s $loc/scripts/polybar-net-conky $HOME/.config/polybar/polybar-net-conky
ln -s $loc/scripts/polybar-net-conky $HOME/.config/polybar/polybar-net-conky-short
cp $loc/scripts/volume.sh $HOME/.config/polybar/volume.sh
sudo ln -r -s $loc/xorg.conf.d /etc/X11/
sudo cp $loc/scripts/backup-weekly.sh /etc/cron.weekly/backup
sudo cp $loc/scripts/backup-daily.sh /etc/cron.daily/backup
sudo chmod +x /etc/cron.weekly/backup
sudo chmod +x /etc/cron.daily/backup
sudo cp $loc/scripts/pre-suspend.sh /usr/lib/systemd/system-sleep/
sudo chmod +x /usr/lib/systemd/system-sleep/pre-suspend.sh
sudo cp $loc/configs/mc-custom-skin.ini /usr/share/mc/skins/mc-custom.ini
echo "Configs Linked"

if [ $(cat "$HOME/.config/gtk-3.0/gtk.css" | grep ".termite" | wc -l) == 0 ]; then 
    echo ".termite {" >> $HOME/.config/gtk-3.0/gtk.css
    echo "    padding: 8px;" >> $HOME/.config/gtk-3.0/gtk.css
    echo "}" >> $HOME/.config/gtk-3.0/gtk.css
    echo "gtk.css Updated"
else 
    echo "Termite already styled in gtk.css"
fi

if [ $1 == "quick" ]; then 
    exit 0
fi

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
pgms+=("nmcli")
pgms+=("conky")
pgms+=("i3lock-color")
pgms+=("sddm")
pgms+=("sddm-maia-theme")
pgms+=("papirus-maia-icon-theme")
pgms+=("ttf-emojione-color")
pgms+=("ttf-font-awesome")
pgms+=("vimix-gtk-themes-git")
pgms+=("dunst")
pgms+=("mpc")
# utility
pgms+=("termite")
pgms+=("lxappearance")
#pgms+=("pcmanfm")
pgms+=("gparted")
pgms+=("neofetch")
pgms+=("pcloudcc")
pgms+=("kdeconnectd")
pgms+=("openvpn")
pgms+=("calc")
pgms+=("ncmpcpp")
pgms+=("mplayer")
# applications
pgms+=("gimp")
pgms+=("transmission-gtk")
pgms+=("visual-studio-code-bin")

exec yay -S ${pgms[*]}
