#!/bin/sh -e
# $ bash ~/.i3/scripts/i3locker.#!/bin/sh

## Blur i3lock
# Take a screenshot
#scrot /tmp/screen_locked.png
# Pixellate it 10x
#mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
#mogrify /tmp/screen_locked.png -blur 0x8 /tmp/screen_locked.png
# Lock screen displaying this image.
#i3lock -i /tmp/screen_locked.png -e -u

function locker {
    i3lock -e --color=$backcolor --indicator --force-clock \
    --insidevercolor=$highcolor --insidewrongcolor=$errorcolor --insidecolor=$highcolor \
    --ringvercolor=$plaincolor --ringwrongcolor=$errorcolor --ringcolor=2EB398FF \
    --linecolor=$linecolor --keyhlcolor=$plaincolor --bshlcolor=$errorcolor --separatorcolor=$linecolor \
    --veriftext="" --wrongtext="" --noinputtext="" --locktext="" --lockfailedtext="" \
    --datestr="%a %Y-%m-%d" --time-font=Monospace --date-font=Monospace
}

## Color i3lock
backcolor="141A1B"
plaincolor="EEEEEEFF"
highcolor="2EB398FF"
errorcolor="DB5B5BFF"
linecolor="141A1BFF"

# connected monitors
screens="$(xrandr | grep " connected" | wc -l)"
# video player running
totem="$(pgrep totem | wc -l)"
# write info to lock-log.txt
echo "Locker:  $screens $totem $(date +%Y-%m-%d_%H:%M:%S) $1" >> /home/penn/.i3/scripts/lock-log.txt

# nofies on auto lock
if [ $1 == "auto" ]; then
    if [[ $screens > 1 ]]; then 
        zenity --notification --text="lock triggered (HDMI attached)"
    elif [[ $totem > 0 ]]; then
        zenity --notification --text="lock triggered (video playing)"
    else 
        locker
    fi
else
    locker

    # Turn the screen off after a delay.
    if [[ $1 = "dark" ]]; then
        sleep 10; pgrep i3lock && xset dpms force off
    fi
fi


