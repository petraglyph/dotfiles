#!/bin/sh 

if [[ $1 == "network" ]]; then
	dev=$(nmcli | grep connected | head -n 1 | cut -d":" -f 1)
	info=$(nmcli dev show)
	while [[ $(echo $"$info" | head -n 1 | grep "$dev" | wc -l) == 0 ]]; do
		info=$(echo $"$info" | tail -n +2)
	done
	ip4=$(echo $"$info" | grep "IP4.ADDRESS" | head -n 1 | cut -d":" -f 2)
	ip6=$(echo $"$info" | grep "IP6.ADDRESS" | head -n 1 | cut -d":" -f 2,3,4,5,6,7)
	mac=$(echo $"$info" | grep "GENERAL.HWADDR" | head -n 1 | cut -d":" -f 2,3,4,5,6,7)
	notify-send -u low -t 5000 "Network" "$(printf 'IP4: %s\nIP6: %s\nMAC: %s' $ip4 $ip6 $mac)"
	echo "1" >> /home/penn/Storage/Linux/i3-config/scripts/log
	exit 0
elif [[ $1 == "disk" ]]; then 
	main=$(df -h | grep "/$" | cut -d"%" -f 1)
	store=$(df -h | grep "/home/penn/storage" | cut -d"%" -f 1)
	pcloud=$(df -h | grep "/home/penn/pCloudDrive" | cut -d"%" -f 1)
	exec dunstify -u low -t 5000 "Storage" "$(printf 'Disk:    %s%%\nStorage: %s%%\npCloud:  %s%%' ${main: -2} ${store: -2} ${pcloud: -2})"
fi
