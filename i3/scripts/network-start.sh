#!/bin/bash
# Connect to WiFi
#   Penn Bauman <me@pennbauman.com>

while [[ $(cat /proc/net/route) =~ 'wlp(59|41)s0|enp39s0' ]]; do
	wifis=$(nmcli dev wifi list)
	#echo "$wifis"
	if [[ "$wifis" =~ "121JumpStreet" ]]; then
		echo "121JumpStreet"
		nmcli con up "121JumpStreet"
	elif [[ "$wifis" =~ "eduroam" ]]; then
		echo "eduroam"
		nmcli con up "eduroam"
	elif [[ "$wifis" =~ "Bakuman" ]]; then
		echo "Bakuman"
		nmcli con up "Bakuman"
	else
		echo "none"
		break
	fi
done

while [[ $(mount | grep pCloudDrive | wc -l) == 0 ]]; do
	sleep 1
done
rm -rf $HOME/pCloudDrive/System\ Volume\ Information
