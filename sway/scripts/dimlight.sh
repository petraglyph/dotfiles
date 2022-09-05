#!/bin/sh
# Dim Screen Colors in Wayland
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles/.local"

if [ -f $loc/dimbright ]; then
	current=$(sed '1q;d' $loc/dimbright)
	if [ -z "$current" ]; then
		current=1.0
	fi
else
	mkdir -p $loc
	current="1.0"
fi
echo "prev: $current"

new=$current
if [ $# -eq 0 ]; then
	echo "missing operator"
	exit 1
fi
if [ "$1" = "+" ]; then
	new=$(echo "scale = 4; $current*1.5" | bc)
elif [ "$1" = "-" ]; then
	new=$(echo "scale = 4; $current/1.5" | bc)
else
	echo "unknown operator"
	exit 1
fi
if [ $(echo "$new >= 1.0" | bc) -eq 1 ]; then
	new="1.0"
fi
if [ $(echo "$new < 0.1" | bc) -eq 1 ]; then
	new="0.1"
fi
echo "new:  $new"

echo "$new" > $loc/dimbright
prev=$(pgrep gammastep)
#redshift -P -o -r -b "$new:$new"
kill $prev
gammastep -r -b $new -l "38:-78" &
