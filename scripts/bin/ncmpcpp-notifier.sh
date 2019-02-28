#!/bin/sh

title=$(mpc -f "%title%" | head -1)
artist=$(mpc -f "%artist%" | head -1)
album=$(mpc -f "%album%" | head -1)

ws=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
if [[ ${ws:0:2} != "10" ]]; then
    dunstify -u low -t 2000 -r "1" "$title" "$artist - $album"
fi