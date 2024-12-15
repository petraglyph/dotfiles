#!/bin/sh
# Install and Setup transmission-daemon
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
SYSTEMD_DIR="$HOME/.config/systemd/user"
CONFIG_DIR="$HOME/.config/transmission-daemon"
DATA_DIR="$HOME/transmission"
HERE="$(dirname $(realpath $0))"

if [ -z "$(command -v transmission-daemon)" ]; then
	printf "\033[1;31m%s\033[0m\n" "transmission-daemon not installed"
	exit 1
fi


# Pause service
systemctl --user stop transmission-daemon
if [ -z "$(transmission-remote -l 2>&1 | grep "Couldn't connect")" ]; then
	echo "transmission-daemon already running as system service"
	exit 1
fi

printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Adding systemd user service"
mkdir -p $SYSTEMD_DIR
cp $HERE/systemd-user.service $SYSTEMD_DIR/transmission-daemon.service

# Create working directories
mkdir -p $CONFIG_DIR $DATA_DIR/watch $DATA_DIR/dowloads $DATA_DIR/partial
# Configure daemon
if [ -f $CONFIG_DIR/settings.json ]; then
	printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Already configured"
else
	printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Configuring daemon"
	cp $HERE/settings.json $CONFIG_DIR/settings.json
	sed -i "s/DATA_DIR/$(echo "$DATA_DIR" | sed 's/\//\\\//g')/" $CONFIG_DIR/settings.json
	read -p "RPC Password: " input
	sed -i "s/PASSWORD/$input/" $CONFIG_DIR/settings.json
fi

printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Starting service"
systemctl --user daemon-reload
systemctl enable --user transmission-daemon
systemctl start --user transmission-daemon
