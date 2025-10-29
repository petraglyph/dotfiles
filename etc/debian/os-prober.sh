#!/bin/sh
# Enable OS Prober on Debian
#   Petra E Bauman <petra.e.bauman@gmail.com>
#   https://codeberg.org/petraglyph/dotfiles

sudo apt-get -y install os-prober

name="GRUB_DISABLE_OS_PROBER"
if [ -z "$(grep -E "^$name" /etc/default/grub)" ]; then
	if [ -z "$(grep -E "^#$name" /etc/default/grub)" ]; then
		echo "$name=false" | sudo tee -a /etc/default/grub > /dev/null
	else
		sudo sed -i /etc/default/grub -E -e "s/^#$name=[a-z]+ *$/$name=false/g"
	fi
else
	sudo sed -i /etc/default/grub -E -e "s/^$name=[a-z]+ *$/$name=false/g"
fi

sudo update-grub2
