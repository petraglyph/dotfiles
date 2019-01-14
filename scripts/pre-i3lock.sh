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

# connected monitors
screens="$(xrandr | grep " connected" | wc -l)"
# video player running
totem="$(pgrep totem | wc -l)"
# write info to lock-log.txt
echo "PreLock: $screens $totem $(date +%Y-%m-%d_%H:%M:%S) $1" >> /home/penn/.i3/scripts/lock-log.txt

if [[ $screens > 1 ]]; then
    dunstify -r "1" "prelock triggered (HDMI attached)" 
    mouser
elif [[ $totem > 0 ]]; then
    dunstify -r "1" "prelock triggered (video playing)"
    mouser
else 
    xset dpms force off
fi
