#/bin/sh
# IPTables Force Transmission Through VPN

#http://localhost:9091/
#transmission-daemon --config-dir /home/penn/.config/transmission --auth --username penn --password penn --port 9091 --allowed "127.0.0.1"
#sudo -u transmission -- /usr/bin/transmission-daemon 
#--config-dir /home/penn/.config/transmission --auth --username penn --password penn --port 9091 --allowed "127.0.0.1"

#sudo -u transmission -- /usr/bin/transmission-gtk --config-dir /home/penn/.config/transmission

sudo iptables -A OUTPUT -m owner --uid-owner transmission -d 192.168.1.0/24 -j ACCEPT 
sudo iptables -A OUTPUT -m owner --uid-owner transmission \! -o tun0 -j REJECT 

sudo iptables -A OUTPUT -p udp -m multiport --ports 6400 -d 192.168.1.0/24 -j ACCEPT 
sudo iptables -A OUTPUT -p udp -m multiport --ports 6400 \! -o tun0 -j REJECT 
sudo iptables -A OUTPUT -p udp -m multiport --ports 6400 -d 192.168.1.0/24 -j ACCEPT 
sudo iptables -A OUTPUT -p udp -m multiport --ports 6400 \! -o tun0 -j REJECT