#!/bin/bash
# Desktop Configuration

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
source "$(dirname $BASH_SOURCE)/check.sh" "$comp"

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi


# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp

message "Linking Desktop Configs"
ln -fs $loc/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $loc/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $loc/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $loc/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-3.0/settings.ini
ln -fs $loc/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs


message "Setting Up Crontab"
echo "@daily rm -rf \$(find /var/cache/ -type f -mtime +30 -print)" | sudo crontab -
if [[ $(crontab -l) == "" ]]; then
	if [ -f $loc/$comp/crontab.txt ]; then
		crontab $loc/$comp/crontab.txt
	else
		crontab $loc/configs/crontab.txt
	fi
fi

message "Setting Up Root Zsh"
sudo chsh -s /usr/bin/zsh root
sudo cp -f $loc/configs/zshrc-root /root/.zshrc


message "Running External Setup"
if [ -e $HOME/documents/other/linux/scripts/setup.sh ]; then
	bash $HOME/documents/other/linux/scripts/setup.sh
else
	error "  ~linux/scripts/setup.sh not available"
fi
