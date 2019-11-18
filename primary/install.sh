#/bin/sh
# bash scripts/install.sh [quick]

loc="/home/penn/Storage/linux/i3-config"

# REMOVE EXISTING CONFIGS
rm $HOME/.config/i3/config
rm $HOME/.config/rofi/config
rm $HOME/.config/termite/config
rm $HOME/.config/dunst/dunstrc
rm $HOME/.config/ncmpcpp/config
rm $HOME/.config/ncmpcpp/bindings
rm $HOME/.config/polybar/config
rm $HOME/.config/mpd/mpd.conf
rm -r $HOME/.config/ranger
rm $HOME/.zshrc
rm $HOME/.vimrc
rm -r $HOME/.vim

sudo rm -rf /etc/X11/xorg.conf.d
sudo chattr -i /etc/resolv.conf
sudo rm /etc/resolv.conf
echo "Configs Cleared"

# LINK NEW CONFIGS
ln -s $loc/primary/config $HOME/.config/i3/config
ln -s $loc/configs/rofi-config $HOME/.config/rofi/config
ln -s $loc/configs/termite-config $HOME/.config/termite/config
ln -s $loc/configs/dunstrc $HOME/.config/dunst/dunstrc
ln -s $loc/configs/ncmpcpp-config $HOME/.config/ncmpcpp/config
ln -s $loc/configs/ncmpcpp-bindings $HOME/.config/ncmpcpp/bindings
ln -s $loc/configs/polybar $HOME/.config/polybar/config
ln -s $loc/configs/mpd.conf $HOME/.config/mpd/mpd.conf
ln -s $loc/configs/ranger $HOME/.config/ranger
ln -s $loc/configs/zshrc $HOME/.zshrc
ln -s $loc/configs/vimrc $HOME/.vimrc
ln -s $loc/configs/vim $HOME/.vim

sudo cp -r $loc/configs/xorg.conf.d /etc/X11/
sudo cp $loc/configs/resolv.conf /etc/
sudo chattr -i /etc/resolv.conf
echo "Configs Linked"


# CREATE ~/.bin
if [ ! -d $HOME/.bin ]; then
	mkdir $HOME/.bin
fi
for f in $loc/scripts/*; do
	rm -f $HOME/.bin/${f:$(echo "$loc/scripts" | wc -c)}
	if [[ "${f: -5}" != ".json" ]]; then
		ln -s $f $HOME/.bin/${f:$(echo "$loc/scripts" | wc -c)}
	fi
done
chmod 755 ~/.bin/*
echo "~/.bin/ created"


# EDIT TERMITE GTK CSS
if [ $(cat "$HOME/.config/gtk-3.0/gtk.css" | grep ".termite" | wc -l) == 0 ]; then 
    echo ".termite {" >> $HOME/.config/gtk-3.0/gtk.css
    echo "    padding: 8px;" >> $HOME/.config/gtk-3.0/gtk.css
    echo "}" >> $HOME/.config/gtk-3.0/gtk.css
    echo "gtk.css Updated"
else 
    echo "Termite already styled in gtk.css"
fi
