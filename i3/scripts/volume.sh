#!/bin/sh
# Print volume for polybar
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles
ERROR_OUTPUT="%{F#DB5B5B}%{F}[]%"
if [ -z "$(command -v pactl)" ]; then
	echo "$ERROR_OUTPUT"
	exit 1
fi

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2> /dev/null | grep -oE '[0-9]*%' | head -n 1 | sed 's/%//')
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2> /dev/null)

if [ -z "$vol" ]; then
	echo "$ERROR_OUTPUT"
	exit 1
fi

if [ "$vol" -gt 100 ]; then
    color="DB5B5B"
else
    color="2EB398"
fi
if [ "$vol" -eq 0 ] || [ -n "$(echo $mute | grep yes)" ]; then
    icon="󰝟"
elif [ "$vol" -le 50 ]; then
    icon="󰖀"
else
    icon="󰕾"
fi
echo $(printf '%%{F#%s}%s%%{F}%02d%%' $color $icon $vol)
