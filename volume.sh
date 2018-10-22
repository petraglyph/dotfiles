#/bin/sh
vol="$(pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"

#vol="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
if (( $vol < 10 )); then
    echo "0$vol"
else
    echo "$vol"
fi
