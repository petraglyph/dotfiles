#!/bin/sh
# Toggle trayer on/off
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

if [ $(pgrep trayer -c) -eq 0 ]; then
	trayer --transparent true --tint 0 \
		--edge top --align right --SetDockType false \
		--widthtype request --height 50 &
else
	pkill trayer
fi
