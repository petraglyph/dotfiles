#!/bin/sh

Bcolor="#141A1B"
Tcolor="#EEEEEE"
Hcolor="#2EB398"
Ecolor="#DB5B5B"
#iconLoc="/home/penn/Storage/Git/i3-dzen2-bridge/xbm-icons"
#conLoc="/home/penn/Storage/Linux/i3-config/icons"

DZEN="dzen2 -bg $Bcolor -fg $Tcolor -x 2130 -h 50 -w 1710 -ta r -fn Monospace:size=10 -p 10"

# 3840
# 1710 + 420 +1710

i=0
while true; do 
    # NETWORK
    # Wifi 來 冷爛嵐襤蠟 狼鸞藍臘朗
    # Volume    
    # System    
    # Battery  
    # Other  串
    # Weather                  
    # Desktops 降   ﱨ粒精      
    #       精      
    #print="^tar^fn(Material Design Icons)   精      ^fn()^tar "
    #print="^fn(Material Icons)          ^fn() "

    # 1 Hour
    if (( $i%3600 == 0 )); then 
        # UPDATES
        updates=$(
            available=$(yay -Qu | wc -l)
            if [[ $available != 0 ]]; then
                x="^fg($Hcolor)^fn(Material Design Icons)^fn()^fg()$available "
            fi
            echo $x
        )
    fi

    # 15 Seconds
    if (( $i%15 == 0 )); then 
        battery=$(
            perc=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage" | cut -d':' -f 2 | cut -d'%' -f 1)
            perc=$(printf '%s' $perc)
            state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "state" | cut -d':' -f 2 | cut -d'%' -f 1)
            state=$(printf '%s' $state)
            # Battery  
            if [[ $state == "discharging" ]]; then 
                if (( $perc == 100 )); then 
                    icon=""
                elif (( $perc > 91 )); then 
                    icon=""
                elif (( $perc > 82 )); then 
                    icon=""
                elif (( $perc > 73 )); then 
                    icon=""
                elif (( $perc > 64 )); then 
                    icon=""
                elif (( $perc > 55 )); then 
                    icon=""
                elif (( $perc > 46 )); then 
                    icon=""
                elif (( $perc > 37 )); then 
                    icon=""
                elif (( $perc > 28 )); then 
                    icon=""
                elif (( $perc > 19 )); then 
                    icon=""
                else 
                    icon=""
                fi
            else 
                icon=""
            fi 
            if (( $perc > 25 )); then 
                color=$Hcolor 
            else 
                color=$Ecolor 
            fi
            echo $(printf '^fg(%s)^fn(Material Design Icons)%s^fn()^fg()^fn()%s%%'  $color $icon $perc)
        )
        # STORAGE
    fi 

    # 5 Seconds
    if (( $i%5 == 0 )); then 
        memory=$(
            ram=$(awk '/MemTotal:/{total=$2}/MemAvailable:/{free=$2;print int(100-100/(total/free))}' /proc/meminfo)
            mem=""
            #print+="^fg($Hcolor)^i(/memory.xbm) "
            echo $(printf '^fg(%s)^fn(Material Design Icons)^fn()^fg()%02d%%' $Hcolor "$ram")
        )
    fi

    # 1 Second
    if (( $i%1 == 0 )); then 
        volume=$(
            vol=$(pamixer --get-volume)
            if (( $vol > 100 )); then 
                color=$Ecolor
            else 
                color=$Hcolor
            fi 
            if (( $vol == 0 )); then 
                icon=""
            elif (( $vol < 50 )); then 
                icon=""
            else 
                icon=""
            fi
            #volume="^fg($color)^i($iconLoc/volume_$icon.xbm)^fg()$vol% "
            #volume=$(printf '^fg(%s)^i(%s/volume_%s.xbm)^fg()%02d%% ' $color $iconLoc $icon $vol)
            x=$(printf '^fg(%s)^fn(Material Design Icons)%s^fn()^fg()%02d%%' $color "$icon" $vol)
            echo $x
        ) 

        cpu=$(
            perc=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
            perc=$(printf '%.0f' $perc)
            if (( $perc > 80 )); then 
                color=$Ecolor 
            else 
                color=$Hcolor 
            fi
            echo $(printf '^fg(%s)^fn(Material Design Icons)^fn()^fg()%02d%%' $color $perc)
        )
    fi
    
    print="$updates $volume $memory $cpu $battery "
    print+="n=$i "
    echo "$print"

    i=$(($i + 1))
    sleep 1
done | $DZEN &
