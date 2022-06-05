#!/bin/sh
# Print volume for polybar

vol=$(amixer -D pipewire sget Master | grep -oE '\[[0-9]*%\]' | head -n 1 | grep -oE '[0-9]*')
mute=$(amixer -D pipewire sget Master | grep -oE '\[[0-9]*%\] \[[a-z]*\]')

if [ $vol -gt 100 ]; then
    color="DB5B5B"
else
    color="2EB398"
fi
if [ $vol -eq 0 ] || [ -n "$(echo $mute | grep off)" ]; then
    icon=""
elif [ $vol -le 50 ]; then
    icon=""
else
    icon=""
fi
echo $(printf '%%{F#%s}%s%%{F}%02d%%' $color $icon $vol)
