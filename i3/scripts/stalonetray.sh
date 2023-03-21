#!/bin/sh
# Toggle stalonetray on/off
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ $(pgrep stalonetray -c) -eq 0 ]; then
	stalonetray &
else
	killall stalonetray
fi
