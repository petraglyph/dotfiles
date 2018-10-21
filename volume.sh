#/bin/sh
vol="$(pactl list sinks | grep 'Volume: front-left')"
echo $vol
echo ${#vol}
#vol="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
i=0
while :; do
    echo "i = $i : ${vol:($i):($i)}"
    if [[ ${vol:($i):($i)} == "%" ]]; then
        echo "found %"
        echo ${vol:0:$i}
        break
    elif [[ ${vol:$i:($i+1)} == " " ]]; then
        echo "found \" \""
        vol=${vol:0:$i}
        i=0
    fi
    if (( $i > ${#vol} )); then
        break
    fi
    i=$(($i + 1))
done

#if [[ ${vol:1:2} = "%" ]]; then
#    echo "0$vol  "
#else
#    echo "$vol  "
#fi

#if [[ ${vol:0:1} > 4 ]];then
#    echo "> 50%"
#fi
#if [[ ${vol:0:1} < 5 ]];then
#    echo "< 50%"
#fi
#if [[ ${vol:1:2} = "%" ]]; then
#    echo "< 10%"
#fi
