#!/bin/sh
# Connect to WiFi
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

while [ -z "$(grep -E '(wlp41s0|enp39s0|wlo1)' /proc/net/route)" ]; do
	wifis=$(nmcli dev wifi list)
	#echo "$wifis"
	if [ $(echo $wifis | grep "121JumpStreet" | wc -l) -ne 0 ]; then
		echo "121JumpStreet"
		nmcli con up "121JumpStreet"
	elif [ $(echo $wifis | grep "eduroam" | wc -l) -ne 0 ]; then
		echo "eduroam"
		nmcli con up "eduroam"
	elif [ $(echo $wifis | grep "Bakuman" | wc -l) -ne 0 ]; then
		echo "Bakuman"
		nmcli con up "Bakuman"
	else
		echo "none"
		break
	fi
done

while [ -z "$(mount | grep pCloudDrive)" ]; do
	sleep 1
done
rm -rf $HOME/pCloudDrive/System\ Volume\ Information
