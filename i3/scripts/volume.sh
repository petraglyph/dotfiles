#!/bin/sh
# Print volume for polybar
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]*%' | head -n 1 | sed 's/%//')
mute=$(pactl get-sink-mute @DEFAULT_SINK@)

if [ "$vol" -gt 100 ]; then
    color="DB5B5B"
else
    color="2EB398"
fi
if [ "$vol" -eq 0 ] || [ -n "$(echo $mute | grep yes)" ]; then
    icon=""
elif [ "$vol" -le 50 ]; then
    icon=""
else
    icon=""
fi
echo $(printf '%%{F#%s}%s%%{F}%02d%%' $color $icon $vol)
