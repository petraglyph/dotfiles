#!/bin/sh
# Start and Setup mpd and ncmpcpp
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

term=$1

mpd
$term --title="ncmpcpp" -e ncmpcpp &

while ! $(mpc &> /dev/null); do
	sleep 1
done
mpc random on
mpc repeat on
