#!/bin/sh -e

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixellate it 10x
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
#mogrify /tmp/screen_locked.png -blur 0x8 /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png -e -u

# Turn the screen off after a delay.
if [[ $1 = "dark" ]]; then
    sleep 10; pgrep i3lock && xset dpms force off
fi
