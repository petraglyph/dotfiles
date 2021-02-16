#/bin/sh
# Exit sway

echo "i3 System"
echo "  [s] shutdown"
echo "  [r] reboot"
echo "  [e] exit sway"
echo "  [c] cancel"
while true; do
    read -p ": " t
	case $t in
		s) systemctl poweroff
			exit 0;;
		r) systemctl reboot
			exit 0;;
		e) swaymsg exit
			exit 0;;
		c) exit 0;;
		*) echo " Invalid input."
	esac
done
