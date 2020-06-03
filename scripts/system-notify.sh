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
	notify-send -u low -t 5000 "Network" "$(printf 'IPv4: %s\nIPv6: %s\nMAC: %s' $ip4 $ip6 $mac)"
	exit 0
elif [[ $1 == "disk" ]]; then
	root_prec="$(df -h --output / | tail -n 1 | xargs | cut -d" " -f 10)"
	root_size="($(df -h --output / | tail -n 1 | xargs | cut -d" " -f 8)/$(df -h --output / | tail -n 1 | xargs | cut -d" " -f 7))"

	home_prec="$(df -h --output /home | tail -n 1 | xargs | cut -d" " -f 10)"
	home_size="($(df -h --output /home | tail -n 1 | xargs | cut -d" " -f 8)/$(df -h --output /home | tail -n 1 | xargs | cut -d" " -f 7))"

	store_prec="$(df -h --output /mnt/storage | tail -n 1 | xargs | cut -d" " -f 10)"
	store_size="($(df -h --output /mnt/storage | tail -n 1 | xargs | cut -d" " -f 8)/$(df -h --output $HOME/storage | tail -n 1 | xargs | cut -d" " -f 7))"

	pcloud_prec="$(df -h --output $HOME/pCloudDrive | tail -n 1 | xargs | cut -d" " -f 10)"
	pcloud_size="($(df -h --output $HOME/pCloudDrive | tail -n 1 | xargs | cut -d" " -f 8)/$(df -h --output $HOME/pCloudDrive | tail -n 1 | xargs | cut -d" " -f 7))"

	message="Root:    $root_prec $(printf '%11s' $root_size)"
	if [[ $(df -h | grep /home$ | wc -l) != 0 ]]; then
		message="$message\nHome:    $home_prec $(printf '%11s' $home_size)"
	fi
	if [[ $(df -h | grep /storage$ | wc -l) != 0 ]]; then
		message="$message\nStorage: $store_prec $(printf '%11s' $store_size)"
	fi
	if [[ $(df -h | grep $HOME/pCloudDrive$ | wc -l) != 0 ]]; then
		message="$message\npCloud:  $pcloud_prec $(printf '%11s' $pcloud_size)"
	fi

	notify-send -u low -t 5000 "Storage" "$message"
else
	echo "No target provided"
fi
