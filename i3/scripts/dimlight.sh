#!/bin/sh
# Dim Screen Colors in Xorg
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.dotfiles/.local"

if [ -f $loc/dimbright ]; then
	current=$(sed '1q;d' $loc/dimbright)
else
	mkdir -p $loc
	current="1.0"
fi
echo "$current"

new=$current
if [ $1 = "+" ]; then
	new=$(echo "scale = 4; $current*1.5" | bc)
elif [ $1 = "-" ]; then
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
echo $new

echo "$new" > $loc/dimbright
prev=$(pgrep redshift)
#redshift -P -o -r -b "$new:$new"
redshift -r -b $new -l "38:-78" > /dev/null 2> /dev/null &
kill $prev
