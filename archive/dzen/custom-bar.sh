#!/usr/bin

# Colour names
WHITE=ffffff
LIME=00ff00
GRAY=666666
YELLOW=ffff00
MAROON=cc3300

# Set delimiter to just newlines, instead of any white space
IFS=$'\n'

# text <string> <colour_name>
function text { output+=$(echo -n '{"full_text": "'${1//\"/\\\"}'", "color": "#'${2-$WHITE}'", "separator": false, "separator_block_width": 1}, ') ;}
# sensor <device> <sensor>
function sensor { echo "$SENSORS" | awk '/^'${1}'/' RS='\n\n' | awk -F '[:. ]' '/'${2}':/{print$5}' ;}

echo -e '{ "version": 1 }\n['
while :; do
    WINDOW=( $(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d\  -f5) _NET_WM_NAME WM_CLASS | sed 's/.*\ =\ "\|\",\ \".*\|"$//g;s/\\\"/"/g') )
    MPD=( $(mpc -f ' [%title%|%file%]\n %artist%\n %album%') )
    STATE=$([[ ${MPD[3]/ *} == '[playing]' ]] && echo ' ♪ ▸' || echo ' ♪ װ')
    VOLUME=$(echo ${MPD[4]} | cut -d\  -f2)
    SENSORS="$(sensors -Au)"
    CPU=$(sensor k10 temp1_input) # amdk10
    RAM=$(awk '/MemTotal:/{total=$2}/MemAvailable:/{free=$2;print int(100-100/(total/free))}' /proc/meminfo)
    GPU=$(nvidia-smi -q -d TEMPERATURE | awk '/GPU Current Temp/{print$5}') # nvidia
    #GPU=$(sensor nouveau temp1_input)  # nouveau
    MB1=$(sensor w83627dhg temp1_input)
    MB2=$(sensor w83627dhg temp2_input)
    MB3=$(sensor w83627dhg temp3_input)
    #FPS=$(tail -1 /tmp/voglperf.steam.*.csv) # Need to find an ideal way to setup vogl to run on demand
    DATE=$(date '+%F %T')

    output=''
    text ${WINDOW[1]}\  $GRAY
    text ${WINDOW[0]}
    if [[ ${MPD[0]} != ' ' ]]; then
        text $STATE  $LIME
        text ${MPD[0]}
        if [[ ${MPD[1]} != ' ' ]]; then
            text ' by'   $GRAY
            text ${MPD[1]}
        fi
        if [[ ${MPD[2]} != ' ' ]]; then
            text ' on'   $GRAY
            text ${MPD[2]}
        fi
        text ' for ' $GRAY
        text ${MPD[3]/*  }
        text ' at '  $GRAY
        text $VOLUME
    fi
    text ' ⚡' $YELLOW
    text ' CPU ' $GRAY
    text "$CPU°c"
    text ' RAM ' $GRAY
    text "$RAM%"
    text ' MB ' $GRAY
    text "$MB1"
    text '|' $GRAY
    text "$MB2"
    text '|' $GRAY
    text "$MB3°c"
    text ' GPU ' $GRAY
    text "$GPU°c"
    #text ' FPS ' $GRAY
    #text "$FPS"
    text ' ☕ ' $MAROON
    text "$DATE"
    echo -e "[${output%??}],"
    sleep 0.1
done