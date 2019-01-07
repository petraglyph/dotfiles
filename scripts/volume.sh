#/bin/sh
vol="$(pamixer --get-volume)"

#vol="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
if (( $vol < 10 )); then
    echo "0$vol"
else
    echo "$vol"
fi
