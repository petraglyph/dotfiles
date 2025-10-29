#!/bin/sh
# Start polybar
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

for n in $(pgrep polybar); do
	kill $n
done

# Launch bar1 and bar2
for bar in $@; do
	polybar $bar &
done
