#!/bin/sh

current=$(sed '1q;d' $HOME/.dimbright)
echo "$current"

new=$($HOME/.bin/brightcalc $current $1)
echo $new

echo "$new" > $HOME/.dimbright
prev=$(pgrep redshift)
#redshift -P -o -r -b "$new:$new"
redshift -r -b $new -l "38:-78" &
kill $prev
