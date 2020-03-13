#!/bin/sh

while [ $(cat /proc/net/route | grep "wlp59s0" | wc -l) == 0 ]; do
	wifis=$(nmcli dev wifi list)
	#echo "$wifis"
	#if [ $(exit 0) ]; then
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
	fi
done

while [[ $(mount | grep pCloudDrive | wc -l) == 0 ]]; do
	#echo "not p"
	sleep 1
	rm -rf $HOME/pCloudDrive/System\ Volume\ Information
done
