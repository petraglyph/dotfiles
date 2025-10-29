#!/bin/sh
# i3 Exit Script
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

echo "i3 System"
echo "  [s] shutdown"
echo "  [r] reboot"
echo "  [e] exit i3"
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
		c) exit 0;;
		*) echo " Invalid input."
	esac
done
