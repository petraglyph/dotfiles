#!/bin/bash
# Start and Setup mpd and ncmpcpp

term=$1

mpd
$term --title="ncmpcpp" -e ncmpcpp &

while ! $(mpc &> /dev/null); do
	sleep 1
done
mpc random on
mpc repeat on
