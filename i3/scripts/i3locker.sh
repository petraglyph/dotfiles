#/bin/bash -e
# $ bash ~/.i3/scripts/i3locker.#!/bin/sh

## Color i3lock
backcolor="000000FF"
plaincolor="EEEEEEFF"
highcolor="2EB398FF"
errorcolor="DB5B5BFF"
linecolor="000000FF"

i3lock -e --color=$backcolor --indicator --force-clock --radius=100 --ring-width=9 \
--insidevercolor=$linecolor --insidewrongcolor=$linecolor --insidecolor=$linecolor \
--ringvercolor=$plaincolor --ringwrongcolor=$errorcolor --ringcolor=$highcolor \
--linecolor=$linecolor --keyhlcolor=$plaincolor --bshlcolor=$errorcolor --separatorcolor=$linecolor \
--veriftext="" --wrongtext="" --noinputtext="" --locktext="" --lockfailedtext="" --datestr="%a %Y-%m-%d" \
--timecolor=$highcolor --datecolor=$plaincolor --time-font=Monospace --date-font=Monospace

# Turn the screen off after a delay.
if [[ $1 = "dark" ]]; then
	sleep 5
	xset dpms force off
elif [[ $1 = "suspend" ]]; then
	sleep 1
	systemctl suspend
fi
