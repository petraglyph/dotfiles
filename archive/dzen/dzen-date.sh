#!/bin/sh

Bcolor="#141A1B"
Tcolor="#EEEEEE"

DZEN="dzen2 -bg $Bcolor -fg $Tcolor -x 1710 -h 50 -w 420 -fn Monospace:size=10"

# 3840
# 1710 + 420 +1710

while true; do 
    echo $(date '+%a %Y-%m-%d %H:%M:%S')
    sleep 1
done | $DZEN &