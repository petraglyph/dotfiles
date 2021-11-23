#!/bin/bash

vol=$(amixer -D pipewire sget Master | grep -oE '\[[0-9]*%\]' | head -n 1 | grep -oE '[0-9]*')
mute=$(amixer -D pipewire sget Master | grep -oE '\[[0-9]*%\] \[[a-z]*\]')

if (( $vol > 100 )); then 
    color="DB5B5B"
else
    color="2EB398"
fi
if (( $vol == 0 )) || [[ $mute =~ off ]]; then 
    icon=""
elif (( $vol < 50 )); then 
    icon=""
else 
    icon=""
fi
echo $(printf '%%{F#%s}%s%%{F}%02d%%' $color $icon $vol)
