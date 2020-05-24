#/bin/sh
# bash scripts/install.sh [quick]

# SET AND CHECK LCOATION
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi
if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME=$HOME/.local/share
fi
loc="$HOME/.i3-config"
if [[ $(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd) != $loc/install ]]; then
	echo "Configuration not properly located, it should be at ~/.i3-config/"
	exit 1
fi


# GET POSSIBLE COMPUTERS
computers=()
for f in $loc/*; do
	if [ -d $f ]; then
		d=$(basename $f)
		if [[ $d != "configs" && $d != "scripts" && $d != "install" ]]; then
			#echo $d
			computers+=($d)
		fi
	fi
done

if [ -z $1 ]; then
	provided_comp=$(hostname)
else
	provided_comp=$1
fi


# SELECT COMPUTER OR THROW ERROR
for c in "${computers[@]}"; do
	if [[ $provided_comp == $c ]]; then
		comp="$provided_comp"
	fi
done
if [[ $comp == "" ]]; then
	echo "Unknown computer, a computer must be provided, options:"
	for c in "${computers[@]}"; do
		echo "  $c"
	done
	exit 1
fi


# REMOVE EXISTING CONFIGS
rm -rf $HOME/.config/ranger
sudo rm -rf /etc/X11/xorg.conf.d


# MAKE NECESSARY DIRECTORIES
mkdir -p $XDG_CONFIG_HOME/i3
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/dunst
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_CONFIG_HOME/polybar
mkdir -p $XDG_CONFIG_HOME/rofi
mkdir -p $XDG_CONFIG_HOME/termite
mkdir -p $XDG_CONFIG_HOME/zathura

mkdir -p $XDG_DATA_HOME/nvim/site/colors
mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes
mkdir -p $XDG_DATA_HOME/fonts


# LINK NEW CONFIGS
ln -fs $loc/$comp/config $XDG_CONFIG_HOME/i3/config
ln -fs $loc/configs/alacritty.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
ln -fs $loc/configs/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
ln -fs $loc/configs/gitconfig $XDG_CONFIG_HOME/git/config
ln -fs $loc/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $loc/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $loc/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $loc/configs/nvim.init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -fs $loc/configs/polybar $XDG_CONFIG_HOME/polybar/config
ln -fs $loc/configs/ranger $XDG_CONFIG_HOME/ranger
ln -fs $loc/configs/rofi-config $XDG_CONFIG_HOME/rofi/config
ln -fs $loc/configs/termite $XDG_CONFIG_HOME/termite/config
ln -fs $loc/configs/zathurarc $XDG_CONFIG_HOME/zathura/zathurarc
ln -fs $loc/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs

ln -fs $loc/configs/profile $HOME/.profile
ln -fs $loc/configs/stalonetrayrc $HOME/.stalonetrayrc
ln -fs $loc/configs/zshrc $HOME/.zshrc
ln -fs $loc/$comp/zsh-dirs $HOME/.zsh-dirs
ln -fs $loc/$comp/Xresources $HOME/.Xresources

ln -fs $loc/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
ln -fs $loc/configs/airline-maia_custom.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim

if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

cp -f $loc/configs/material_design_icons.ttf $XDG_DATA_HOME/fonts/material_design_icons.ttf
sudo cp -rf $loc/$comp/xorg /etc/X11/xorg.conf.d
sudo cp -f $loc/configs/resolv.conf /etc/resolv.conf
sudo chattr -i /etc/resolv.conf
sudo cp -f $loc/configs/zshrc-root /root/.zshrc
echo "Configs Setup"


# CREATE ~/.bin
if [ ! -d $HOME/.bin ]; then
	mkdir $HOME/.bin
fi
chmod 755 $loc/scripts/*
for f in $loc/scripts/*; do
	rm -f $HOME/.bin/$(basename $f)
	ln -s $f $HOME/.bin/$(basename $f)
done
gcc -O2 $loc/scripts/brightcalc.c -o $HOME/.bin/brightcalc
rm -rf $HOME/.bin/*.c
echo "~/.bin/ created"


# EDIT TERMITE GTK CSS
#if [ $(cat "$HOME/.config/gtk-3.0/gtk.css" | grep ".termite" | wc -l) == 0 ]; then
    #echo ".termite {" >> $HOME/.config/gtk-3.0/gtk.css
    #echo "    padding: 8px;" >> $HOME/.config/gtk-3.0/gtk.css
    #echo "}" >> $HOME/.config/gtk-3.0/gtk.css
    #echo "gtk.css Updated"
#else
    #echo "Termite already styled in gtk.css"
#fi
