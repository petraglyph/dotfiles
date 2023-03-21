#!/bin/sh
# System Information Notification Sender
#   Penn Bauman <me@pennbauman.com>
#   https://github.com/pennbauman/dotfiles

if [ $# -eq 0 ]; then
	echo "Missing argument"
	exit 1
fi

if [ $1 = "network" ]; then
	dev=$(nmcli | grep connected | head -n 1 | cut -d":" -f 1)
	info=$(nmcli dev show $dev)
	ip4=$(echo $"$info" | grep IP4.ADDRESS | grep -oE '[.\/0-9]+$')
	ip6=$(echo $"$info" | grep IP6.ADDRESS | grep -oE '[:\/a-f0-9]+$')
	mac=$(echo $"$info" | grep GENERAL.HWADDR | grep -oE '[:A-F0-9]+$')
	notify-send -u low -t 5000 "Network" "$(printf 'IPv4: %s\nIPv6: %s\nMAC: %s' $ip4 $ip6 $mac)"
elif [ $1 = "disk" ]; then
	humanbytes() {
		if [ $(numfmt --to=iec --format="%.0f" $1 | sed 's/[A-Z]//g') -lt 100 ]; then
			echo "$(numfmt --round=nearest --to=iec --format "%.1f" $1)"
		else
			echo "$(numfmt --round=nearest --to=iec --format "%.0f" $1)"
		fi
	}
	printdisk () {
		name=$1
		used=$2
		total=$3

		prec=$((($used * 100)/$total))
		ratio="($(humanbytes $used)/$(humanbytes $total))"
		printf '%-8s %02d%% %12s' $name $prec $ratio
	}
	root_used=$(df -B 1 --output=used / | tail -n 1)
	root_total=$(df -B 1 --output=size / | tail -n 1)
	message="$(printdisk 'Root:' $root_used $root_total)"

	if [ $(df | grep /tank$ | wc -l) -ne 0 ]; then
		tank_used=$(zfs list -H -p -o used tank)
		tank_total=$(($(zfs list -H -p -o avail tank) + $tank_used))
		message="$message\n$(printdisk 'Tank:' $tank_used $tank_total)"
	fi
	if [ $(df | grep $HOME/pCloudDrive$ | wc -l) -ne 0 ]; then
		pcloud_used=$(df -B 1 --output=used ~/pCloudDrive | tail -n 1)
		pcloud_total=$(df -B 1 --output=size ~/pCloudDrive | tail -n 1)
		message="$message\n$(printdisk 'pCloud:' $pcloud_used $pcloud_total)"
	fi
	notify-send -u low -t 5000 "Storage" "$message"
else
	echo "Unknown argument '$1'"
	exit 1
fi
