#!/bin/sh

while [[ $(cat /proc/net/route) =~ 'wlp(59|41)s0|enp39s0' ]]; do
	wifis=$(nmcli dev wifi list)
	#echo "$wifis"
	if [[ "$wifis" =~ "Grandmarc Wireless" ]]; then
		echo "Grandmarc Wireless"
		nmcli con up "Grandmarc Wireless"
	elif [[ "$wifis" =~ "wahoo" ]]; then
		echo "wahoo"
		nmcli con up "wahoo"
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
