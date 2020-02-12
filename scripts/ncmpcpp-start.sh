#!/bin/sh
# Start and Setup mpd and ncmpcpp

term=$1

mpd
$term --title="ncmpcpp" -e ncmpcpp
sleep 10
mpc random on
mpc repeat on
