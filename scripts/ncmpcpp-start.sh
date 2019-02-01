#!/bin/sh
# Start and Setup mpd and ncmpcpp

term=$1

mpd
$term --title="ncmpcpp" -e ncmpcpp
mpc random on
mpc repeat on
bash $HOME/Music/0-Playlists/all-gen.sh
