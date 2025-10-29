#!/bin/sh
# Low Battery Notification Script
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

level=$(cat /sys/class/power_supply/BAT0/capacity)
if [ $level -le 20 ]; then
	notify-send -u critical -t 0 "Battery Low" "$level%"
fi
