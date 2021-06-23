#!/bin/bash

## Lock Color
backcolor="000000FF"
plaincolor="EEEEEEFF"
highcolor="2EB398FF"
errorcolor="DB5B5BFF"
linecolor="000000FF"

swaylock -f --color=$backcolor --indicator-idle-visible --indicator-thickness 15 \
--font Monospace --indicator-radius 150 --ignore-empty-password \
--ring-ver-color $plaincolor --ring-wrong-color $errorcolor --ring-color $highcolor \
--inside-ver-color $linecolor --inside-wrong-color $linecolor --inside-color $linecolor \
--line-color $linecolor --key-hl-color $plaincolor --bs-hl-color $errorcolor \
--separator-color $linecolor \
--inside-color $backcolor \
--ring-clear-color $highcolor --inside-clear-color $backcolor \
--text-color $plaincolor
#--veriftext="" --wrongtext="" --noinputtext="" --locktext="" --lockfailedtext="" --datestr="%a %Y-%m-%d" --indicator --force-clock --time-font=Monospace --date-font=Monospace

# Turn the screen off after a delay.
if [[ $1 = "dark" ]]; then
	sleep 3
	#swaymsg "output * dpms off"
elif [[ $1 = "suspend" ]]; then
	sleep 1
	systemctl suspend
fi
