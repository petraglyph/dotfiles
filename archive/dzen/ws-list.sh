#!/bin/bash

Bcolor="#141A1B"
Tcolor="#EEEEEE"

DZEN="dzen2 -bg $Bcolor -fg $Tcolor -x 0 -h 50 -w 1710 -ta l -fn Monospace:size=10 -p 10"

syms=("" "" "" "" "精" "" "" "" "" "" "")

while true; do
    echo ""
    echo -n "  "
    while read -r ws; do
        read -r active
            echo -n "^fn(Material Design Icons)"
            if [ "$active" = true ]; then
                    echo -n "^fg(#2EB398)${syms[$ws]}^fg()"
            else
                    echo -n "${syms[$ws]}"
            fi
            echo -n "^fn() "
    done < <(i3-msg -t get_workspaces | jshon -a -e num -u -p -e focused -u)
    echo -n " $(mpc -f ' %time% %artist% - %album%' | head -n 1)"
    sleep 0.25
done | $DZEN &