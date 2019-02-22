#!/bin/sh
#Custom sidebar

Bcolor="#141A1B"
Tcolor="#EEEEEE"
Hcolor="#2EB398"
Ecolor="#DB5B5B"

# 3840 x 2160
# 1710 + 420 +1710

DZEN="dzen2 -bg $Bcolor -fg $Tcolor -x 3240 -y 50 -h 2110 -w 600 -ta r -fn Monospace:size=10 -p 10 -sa <l|c|r> -p 10 -l 50"


echo "hi" | $DZEN &