#!/bin/bash

if [ $(pgrep stalonetray -c) -eq 0 ]; then
	stalonetray &
else
	killall stalonetray
fi
