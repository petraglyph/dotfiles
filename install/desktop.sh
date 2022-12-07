#!/bin/sh
# Configure for Desktop Use
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
$(dirname $(readlink -f $0))/check.sh "$comp"
if [ $? -ne 0 ]; then
	exit 1
fi

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi


# Making necessary directories
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp

printf "\033[1;32m%s\033[0m\n" "Linking Desktop Configs"
ln -fs $loc/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $loc/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $loc/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $loc/configs/gtk-settings.ini $XDG_CONFIG_HOME/gtk-3.0/settings.ini
ln -fs $loc/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs


printf "\033[1;32m%s\033[0m\n" "Setting Up Crontab"
if [ ! -f /etc/cron.d/clear-cache ]; then
	echo "@daily rm -rf \$(find /var/cache/ -type f -mtime +30 -print)" | \
		sudo tee /etc/cron.d/clear-cache > /dev/null
fi
if [ "$(crontab -l)" = "" ]; then
	if [ -f $loc/$comp/crontab ]; then
		crontab $loc/$comp/crontab
	else
		crontab $loc/configs/crontab
	fi
fi
