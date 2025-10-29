#!/bin/sh
# Exit Sway
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

echo "Sway System"
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
