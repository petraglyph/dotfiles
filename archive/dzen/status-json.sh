#!/bin/sh
# i3 Status Bar Json

echo '{"version":1}'
echo '['
echo '[],'

Bcolor="#141A1B"
Tcolor="#EEEEEE"
Hcolor="#2EB398"
Ecolor="#DB5B5B"

i=0
battery=""
while true; do 
    print=""
    
    
    if (( $i%5 == 0 )); then 
        perc=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage" | cut -d':' -f 2 | cut -d'%' -f 1)
        if (( $perc > 75 )) || (( $perc > 100 )); then 
            icon=""
        elif (( $perc > 50 )); then 
            icon=""
        elif (( $perc > 25 )); then 
            icon=""
        elif (( $perc > 10 )); then 
            icon=""
        else
            icon=""
        fi
        if (( $perc > 25 )); then 
            color=$Hcolor 
        else 
            color=$Ecolor 
        fi
        battery=$(printf '{"full_text": "%s", "color": "%s", "separator_block_width":10},\n' $icon $color)
        battery+=$(printf '{"full_text": "%s"}\n' $perc)
    fi 
    print+=$battery

    #print+=$(printf ',{ "full_text":"n=%s "}' $i)
    echo "[$print],"
    i=$(($i + 1))
    sleep 1
done

#[
#    { "full_text": "${if_up tun0}${else}$endif", "color": "${if_existing /proc/net/route wlp59s0}\#]]..chigh..[[${else}\#]]..cerror..[[${endif}", "separator_block_width":10},
#    { "full_text": "${if_existing /proc/net/route wlp59s0}${wireless_essid wlp59s0} ${wireless_link_qual_perc wlp59s0}% (${downspeedf wlp59s0}K/${upspeedf wlp59s0}K)${else}Disconnected$endif", "color": "\#]]..ctext..[[" },
#
#    { "full_text": "${if_match ${exec bash ~/.conky/volume.sh} == 0}${else}${if_match ${exec bash ~/.conky/volume.sh} < 50}${else}${endif}${endif}", "color": "${if_match ${exec bash ~/.conky/volume.sh} > 100}\#]]..cerror..[[${else}\#]]..chigh..[[${endif}", "separator_block_width":10},
#    { "full_text": "${exec bash ~/.conky/volume.sh}%", "color": "\#]]..ctext..[[" },
#
#    { "full_text": "", "color": "${if_match ${fs_used_perc /home/penn}>90}\#]]..cerror..[[${else}${if_match ${fs_used_perc /home/penn/Storage}>90}\#]]..cerror..[[${else}\#]]..chigh..[[${endif}${endif}", "separator_block_width":10},
#    { "full_text": "${fs_used_perc /home/penn}% ${fs_used_perc /home/penn/Storage}%", "color": "\#]]..ctext..[[" },
#
#    { "full_text": "", "color": "${if_match $memperc>85}\#]]..cerror..[[${else}${if_match $swapperc>85}\#]]..cerror..[[${else}\#]]..chigh..[[${endif}${endif}", "separator_block_width":10},
#    { "full_text": "${if_match $memperc<10}0${endif}$memperc%${if_match $swapperc>4} ${if_match $swapperc<10}0${endif}${swapperc}%${endif}", "color": "\#]]..ctext..[[" },
#
#    { "full_text": "", "color": "${if_match $cpu>75}\#]]..cerror..[[${else}\#]]..chigh..[[${endif}", "separator_block_width":10},
#    { "full_text": "${if_match $cpu<10}0${endif}${cpu}%", "color": "\#]]..ctext..[[" },
#
#],