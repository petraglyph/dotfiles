#!/bin/sh

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if (( $vol > 100 )); then 
    color="DB5B5B"
else
    color="2EB398"
fi
if (( $vol == 0 )) || [[ $mute == true ]]; then 
    icon=""
elif (( $vol < 50 )); then 
    icon=""
else 
    icon=""
fi
echo $(printf '%%{F#%s}%s%%{F}%02d%%' $color $icon $vol)
