#!/bin/sh -e

## Blur i3lock
# Take a screenshot
#scrot /tmp/screen_locked.png
# Pixellate it 10x
#mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
#mogrify /tmp/screen_locked.png -blur 0x8 /tmp/screen_locked.png
# Lock screen displaying this image.
#i3lock -i /tmp/screen_locked.png -e -u


## Color i3lock
i3lock -e --color=141A1BFF --indicator --force-clock \
--insidevercolor=2EB398FF --insidewrongcolor=DB5B5BFF --insidecolor=2EB398FF \
--ringvercolor=EEEEEEFF --ringwrongcolor=DB5B5BFF --ringcolor=2EB398FF \
--linecolor=141A1BFF --keyhlcolor=EEEEEEFF --bshlcolor=DB5B5BFF --separatorcolor=141A1BFF \
--veriftext="" --wrongtext="" --noinputtext="" --locktext="" --lockfailedtext="" \
--datestr="%a %Y-%m-%d" --time-font=Monospace --date-font=Monospace

#--{time, date, layout, verif, wrong}-font=

# Turn the screen off after a delay.
if [[ $1 = "dark" ]]; then
    sleep 10; pgrep i3lock && xset dpms force off
fi
