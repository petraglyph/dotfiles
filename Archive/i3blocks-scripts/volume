#/bin/sh

vol="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
if [[ ${vol:1:2} = "%" ]]; then
    echo "0$vol  "
else
    echo "$vol  "
fi

#if [[ ${vol:0:1} > 4 ]];then
#    echo "> 50%"
#fi
#if [[ ${vol:0:1} < 5 ]];then
#    echo "< 50%"
#fi
#if [[ ${vol:1:2} = "%" ]]; then
#    echo "< 10%"
#fi
