#!/bin/sh

current=$(xbacklight -get)
echo "$current"
#echo "${current%.*}"
#current=$(echo "$current" | cut -d"." -f 1)
#echo "$current"

if [[ $1 == "+" ]]; then
	new=$(bc <<< "$current * 1.5")
elif [[ $1 == "-" ]]; then
	new=$(bc <<< "$current / 1.5")
else
	echo "ERROR: use '+' or '-'"
	exit 1
fi

echo "$new"

if [[ $(bc <<< "$new < 0.7") == "1" ]]; then
	new="0.7"
elif [[ $(bc <<< "$new > 100") == "1" ]]; then
	new="100"
fi
xbacklight -set "$new"
echo "$new"
