#/bin/sh
# Start polybar

if [[ $(pgrep polybar | wc -l) > 0 ]]; then
    killall -q polybar
    #while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
fi

# Launch bar1 and bar2
polybar pennbar &
polybar hdmibar &