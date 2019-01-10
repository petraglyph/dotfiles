#/bin/sh
# IPTables Force Transmission Through VPN

sudo iptables -A OUTPUT -m owner --uid-owner transmission -d 192.168.1.0/24 -j ACCEPT 
sudo iptables -A OUTPUT -m owner --uid-owner transmission \! -o tun0 -j REJECT 
