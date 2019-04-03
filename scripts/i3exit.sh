#/bin/sh
# i3 Exit

function pacmaner {
	if [ ! -z $(yay -Qu) ]; then
		echo "$(yay -Qu | wc -l) packages ready to update"
		while true; do
			read -p "Would you like to update? [y/n] " $answer
			case $answer in
				y|Y) yay 
					break;;
				n|N) break;; 
				*) echo 'Please enter "y" or "n"';;
			esac
		done
	fi
}

echo "i3 System"
echo "  [s] shutdown"
echo "  [r] reboot"
echo "  [e] exit i3"
echo "  [z] sleep"
#echo "  6) hibernate"
echo "  [l] lock i3"
echo "  [c] cancel"
while true; do 
    read -p ": " t
    if [ $t == "s" ]; then 
		pacmaner
        i3exit shutdown
        exit 0
    elif [ $t == "r" ]; then 
		pacmaner
        i3exit reboot
        exit 0
    elif [ $t == "e" ]; then 
        i3-msg exit
        exit 0
    elif [ $t == "z" ]; then 
        bash i3lock
        xset dpms force off
        i3exit suspend
        exit 0
    elif [ $t == "l" ]; then 
        bash i3locker.sh dark
        exit 0
    elif [ $t == "c" ]; then 
        exit 0
    else 
        echo " Please enter a listed letter."
    fi
done
