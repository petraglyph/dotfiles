#!/bin/sh
# Set ID used by SSH

print_id_rsa () {
	ls -l "$HOME/.ssh/id_rsa" | sed "s/^.*[0-9] $(echo $HOME | sed 's/\//\\\//g')/~/"
}

if [ ! -d "$HOME/.ssh" ]; then
	echo "Missing ~/.ssh/"
	exit 1
fi

if [ ! -L "$HOME/.ssh/id_rsa" ]; then
	if [ -e "$HOME/.ssh/id_rsa" ]; then
		echo "Move ~/.ssh/id_rsa before used, it will be overwritten"
		exit 1
	fi
fi

if [ $# -eq 0 ]; then
	print_id_rsa
	exit
	# echo "Missing key file"
	# exit 1
fi

if [ -f "$1" ]; then
	newkey="$(realpath $1)"
elif [ -f "$HOME/.ssh/$1" ]; then
	newkey="$HOME/.ssh/$1"
elif [ -f "$HOME/.ssh/$1_rsa" ]; then
	newkey="$HOME/.ssh/$1_rsa"
else
	echo "Unknown key '$1'"
	exit 1
fi

rm -f "$HOME/.ssh/id_rsa"
rm -f "$HOME/.ssh/id_rsa.pub"
ln -s "$newkey" "$HOME/.ssh/id_rsa"
ln -s "$newkey.pub" "$HOME/.ssh/id_rsa.pub"
print_id_rsa

