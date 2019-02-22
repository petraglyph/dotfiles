#!/bin/sh

Bcolor="#141A1B"
Tcolor="#EEEEEE"

DZEN="dzen2 -bg $Bcolor -fg $Tcolor -x 2130 -h 50 -w 1710 -ta r -fn Monospace:size=10 -p 10"

exec conky -c $HOME/Storage/Linux/i3-config/scripts/dzen-conky | $DZEN &