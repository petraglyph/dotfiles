#!/bin/sh

current=$(cat $HOME/.dimbright)
echo "$current"

new=$($HOME/.bin/brightcalc $current $1)
echo $new

echo "$new" > $HOME/.dimbright
killall redshift
redshift -r -b "$new:$new" -l "38:-78" &
