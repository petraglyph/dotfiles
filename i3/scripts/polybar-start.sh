#!/bin/sh
# Start polybar
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

for n in $(pgrep polybar); do
	kill $n
done

# Launch bar1 and bar2
for bar in $@; do
	polybar $bar &
done
