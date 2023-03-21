#!/bin/sh
# Low Battery Notification Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

level=$(cat /sys/class/power_supply/BAT0/capacity)
if [ $level -le 20 ]; then
	notify-send -u critical -t 0 "Battery Low" "$level%"
fi
