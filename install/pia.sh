#!/bin/sh
# Setup PIA connections

$loc="~/.dotfiles/.local"

mkdir -p $loc
cd $loc

rm -f openvpn.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip

rm -rf openvpn
unzip openvpn.zip -d openvpn

read -p "username: " username
read -p "password: " password

for f in openvpn/*.ovpn; do
	name="${f:8:-5}"
	#echo "$name"
	nmcli con delete "pia_$name" &> /dev/null
	nmcli con delete "$name" &> /dev/null
	nmcli connection import type openvpn file "$f"
	nmcli con modify "$name" vpn.secret password=$password
	nmcli con modify "$name" +vpn.data password-flags=0 1> /dev/null
	nmcli con modify "$name" +vpn.data username=$username 1> /dev/null
	nmcli con modify "$name" connection.id "pia_$name"
done

