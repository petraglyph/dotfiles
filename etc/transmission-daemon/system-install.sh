#!/bin/sh
# Install and Setup transmission-daemon
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
SYSTEMD_DIR="/etc/systemd/system/transmission-daemon.service.d"
if $(grep -qE '^debian-transmission' /etc/passwd); then
	DAEMON_USER="debian-transmission"
else
	echo "Unknown transmission user"
	exit 1
fi
DATA_DIR="/media/transmission"
HERE="$(dirname $(realpath $0))"

if [ -z "$(command -v transmission-daemon)" ]; then
	printf "\033[1;31m%s\033[0m\n" "transmission-daemon not installed"
	exit 1
fi


# Pause service
sudo systemctl stop transmission-daemon

printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Overriding systemd service"
sudo mkdir -p $SYSTEMD_DIR
sudo cp $HERE/systemd-override.conf $SYSTEMD_DIR/override.conf

printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Configuring daemon"
# Create working directories
sudo mkdir -p $DATA_DIR/config $DATA_DIR/watch $DATA_DIR/downloads $DATA_DIR/partial
# Configure daemon
sudo touch $DATA_DIR/config/settings.json
if [ -z "$(sudo grep "$DATA_DIR/watch\",$" "$DATA_DIR/config/settings.json")" ]; then
	sudo cp $HERE/settings.json $DATA_DIR/config/settings.json
	sudo sed -i "s/DATA_DIR/$(echo "$DATA_DIR" | sed 's/\//\\\//g')/" $DATA_DIR/config/settings.json
fi
if [ ! -z "$(sudo grep "PASSWORD" "$DATA_DIR/config/settings.json")" ]; then
	read -p "RPC Password: " input
	sudo sed -i "s/PASSWORD/$input/" $DATA_DIR/config/settings.json
fi
sudo chown -R $DAEMON_USER:$DAEMON_USER $DATA_DIR

printf "\033[1;32m%s\033[0m\n" "[transmission-daemon] Starting service"
sudo systemctl daemon-reload
sudo systemctl enable transmission-daemon
sudo systemctl start transmission-daemon
