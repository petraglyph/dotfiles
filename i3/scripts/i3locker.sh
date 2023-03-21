#!/bin/sh
# i3 Locking Script
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

## Color i3lock
backcolor="000000FF"
plaincolor="EEEEEEFF"
highcolor="2EB398FF"
errorcolor="DB5B5BFF"
linecolor="000000FF"

i3lock -e --color=$backcolor --indicator --force-clock --radius=100 --ring-width=9 \
--insidever-color=$linecolor --insidewrong-color=$linecolor --inside-color=$linecolor \
--ringver-color=$plaincolor --ringwrong-color=$errorcolor --ring-color=$highcolor \
--line-color=$linecolor --keyhl-color=$plaincolor --bshl-color=$errorcolor --separator-color=$linecolor \
--verif-text="" --wrong-text="" --noinput-text="" --lock-text="" --lockfailed-text="" --date-str="%a %Y-%m-%d" \
--time-color=$highcolor --date-color=$plaincolor --time-font=Monospace --date-font=Monospace

# Turn the screen off after a delay.
if [ "$1" = "dark" ]; then
	sleep 5
	xset dpms force off
elif [ "$1" = "suspend" ]; then
	sleep 1
	systemctl suspend
fi
