#!/bin/sh
# Start and Setup mpd and ncmpcpp
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
TERM_CMD=$1

mpd
$TERM_CMD --title="ncmpcpp" -e ncmpcpp &

while ! $(mpc &> /dev/null); do
	sleep 1
done
mpc random on
mpc repeat on
