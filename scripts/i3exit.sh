#/bin/sh
# i3 Exit

echo "i3 System"
echo "  [s] shutdown"
echo "  [r] reboot"
echo "  [e] exit i3"
#echo "  [z] sleep"
echo "  [c] cancel"
while true; do 
    read -p ": " t
	case $t in
		s) systemctl poweroff
			exit 0;;
		r) systemctl reboot
			exit 0;;
		e) i3-msg exit
			exit 0;;
		#z) bash ~/.bin/i3locker.sh
			#xset dpms force off
			#i3exit suspend
			#exit 0;;
		c) exit 0;;
		*) echo " Invalid input."
	esac
done
