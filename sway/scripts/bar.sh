#!/bin/sh
# Sway Status Bar Command
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles
if [ -z "$(command -v pactl)" ]; then
	echo "Missing pactl"
	exit 1
fi

i=0
while true; do
	# Network
	if [ $(($i % 10)) -eq 0 ]; then
		NET="NET: $(nmcli | head -n 1 | sed 's/^.* //')"
	fi

	# Memory
	if [ $(($i % 5)) -eq 0 ]; then
		MEM="MEM: $(free | grep Mem | awk '{print $3/$2 * 100.0}' | sed 's/\..*$//')%"
	fi

	# Volume
	if [ $(($i % 2)) -eq 0 ]; then
		VOL="VOL: $(pactl get-sink-volume @DEFAULT_SINK@ 2> /dev/null | grep -oE '[0-9]*%' | head -n 1)"
	fi

	# Time
	TIME="$(date +'%Y-%m-%d %T')"


	echo "$NET | $MEM | $VOL | $TIME"
	sleep 1
	i=$(($i + 1))
done
