#!/bin/sh
# Toggle stalonetray on/off

if [ $(pgrep stalonetray -c) -eq 0 ]; then
	stalonetray &
else
	killall stalonetray
fi
