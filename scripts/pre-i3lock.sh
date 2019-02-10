#/bin/sh
# Pre i3lock

function mouser {
    x=$(date +%M)
    y=1001
    while [ $y -ge 1000 ]; do
        y=$RANDOM
    done
    xdotool mousemove $((200+$x)) $((200+$y))
}

# write info to lock-log.txt
#echo "PreLock: $screens $totem $(date +%Y-%m-%d_%H:%M:%S) $1" >> /home/penn/.i3/scripts/lock-log.txt

if [[ $(xrandr | grep " connected" | wc -l) > 1 ]]; then
    mouser
elif [[ $(pgrep totem | wc -l) > 0 ]]; then
    mouser
elif [[ $(pgrep mplayer | wc -l) > 0 ]]; then
    mouser
else 
    xset dpms force off
fi
