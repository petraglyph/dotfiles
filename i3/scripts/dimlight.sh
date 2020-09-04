#!/bin/sh

loc="$HOME/.i3-config"

current=$(sed '1q;d' $loc/local/dimbright)
echo "$current"

new=$($HOME/.i3-config/local/brightcalc $current $1)
echo $new

echo "$new" > $loc/local/dimbright
prev=$(pgrep redshift)
#redshift -P -o -r -b "$new:$new"
redshift -r -b $new -l "38:-78" &
kill $prev
