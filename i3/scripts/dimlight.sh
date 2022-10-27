#!/bin/sh
# Dim Screen Colors in Xorg
#   Penn Bauman <me@pennbauman.com>

loc="$HOME/.local/state"

if [ -f $loc/dimbright ]; then
	current=$(sed '1q;d' $loc/dimbright)
else
	mkdir -p $loc
	current="1.0"
fi
if [ -z "$current" ]; then
	current="1.0"
fi
echo "old: $current"

if [ ! $(command -v bc) ]; then
	echo "Missing dependency 'bc'"
	exit 1
fi
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
echo "new: $new"

echo "$new" > $loc/dimbright
prev=$(pgrep redshift)
redshift -r -b $new -l "38:-78" &> /dev/null &
for p in $prev; do
	kill $p
done
