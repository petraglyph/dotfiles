#/bin/sh
# Pre i3lock

# connected monitors
screens="$(xrandr | grep " connected" | wc -l)"
# video player running
totem="$(pgrep totem | wc -l)"

#echo "Screens: $screens"
#echo "Videos:  $totem"

if [[ $screens > 1 ]] || [[ $totem > 0 ]]; then
    xset dpms force off
else
    xautolock -restart
fi