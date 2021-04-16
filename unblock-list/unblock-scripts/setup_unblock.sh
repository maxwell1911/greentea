#!/bin/sh

##### Do all the next 3 steps manually #####
### create folder
#1#mkdir -p /etc/storage/unblock
# download the setup script
#2#wget -q -O /etc/storage/unblock/setup_unblock.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/setup_unblock.sh
#3#chmod +x /etc/storage/unblock/setup_unblock.sh
###########################
#some not yet used variables#
#user='maxwell'
## Step 1 TOR_ Step 2 TOR user_ Step 7 cron
#router_ip='192.168.1.1'
###########################
# Features should be enabled: #
#1# TOR
#2# DNSCrypt-Proxy (need to be configured immediately) (look 3rd step)
#3# Cron
###########################
# List updates manually #
###########################


### 0. Download some scripts and list
echo 'Download List'
wget -q -O /etc/storage/unblock/unblock.txt https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock.txt

echo 'Download scripts'
echo '1_downloading unblock_ipset.sh'
wget -q -O /etc/storage/unblock/unblock_ipset.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_ipset.sh
chmod +x /etc/storage/unblock/unblock_ipset.sh

echo '2_downloading unblock_update.sh'
wget -q -O /etc/storage/unblock/unblock_update.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_update.sh
chmod +x /etc/storage/unblock/unblock_update.sh

echo 'Downloading is done'
sleep 3


### 1. init ipset
#
echo 'init ipset'
#
echo '
### TOR. Example - load ipset modules.
modprobe ip_set
modprobe ip_set_hash_ip
modprobe ip_set_hash_net #main
modprobe ip_set_bitmap_ip
modprobe ip_set_list_set
modprobe xt_set #main

### TOR. creating of unblock array
ipset create unblock hash:net #main

### TOR. Re-resolve unblock-list sites
/etc/storage/unblock/unblock_ipset.sh &

### comments.some scripts to remember
# /etc/storage/unblock/setup_unblock.sh #main script.Setup
# /etc/storage/unblock/unblock_update.sh #main script.Update
# ipset list unblock #check unblock-ipset array

' >> /etc/storage/start_script.sh
echo 'ipset configuring is done'


### 2. TOR configuring
#
echo 'TOR configuring'
cat /dev/null > /etc/storage/tor/torrc
#
echo '
## See https://www.torproject.org/docs/tor-manual.html,
## for more options you can use in this file.
#User admin
User maxwell
#PidFile /opt/var/run/tor.pid
PidFile /var/run/tor.pid
#ExcludeExitNodes {RU}, {UA}, {BY}, {KZ}, {MD}, {AZ}, {AM}, {GE}, {LY}, {LT}, {TM}, {UZ}, {EE}
ExcludeExitNodes {RU}, {UA}, {AM}, {KG}, {BY}
StrictNodes 1
#TransPort 192.168.1.1:9040 IsolateClientAddr IsolateClientProtocol IsolateDestAddr IsolateDestPort
TransPort 192.168.1.1:9040
#TransPort 127.0.0.1:9040
#DNSPort 127.0.0.1:9053 #onion
#SocksPort 127.0.0.1:9050 #onion
#SocksPort 192.168.1.1:9050 #onion
ExitRelay 0
ExitPolicy reject *:*
ExitPolicy reject6 *:*
#VirtualAddrNetworkIPv4 172.16.0.0/12 #onion
#VirtualAddrNetwork 10.254.0.0/16 #onion
#AutomapHostsOnResolve 1 #onion
#Log notice syslog
#DataDirectory /opt/var/lib/tor
DataDirectory /tmp/tor
### /opt path
#GeoIPFile /opt/share/tor/geoip
#GeoIPFile /usr/share/tor/geoip
#GeoIPFile /tmp/torgeoip/geoip
#GeoIPv6File /opt/share/tor/geoip6
#GeoIPv6File /usr/share/tor/geoip6
#GeoIPv6File /tmp/torgeoip/geoip6

' >> /etc/storage/tor/torrc
echo 'TOR configuring is done'


### 3. dnscrypt-proxy
#
echo '3_dnscrypt-proxy should be configured manually'
echo 'Go to Administration - Services. Turn ON Service "DNSCrypt proxy". Then "Apply".'
#resolver: cisco
#local_ip_address: 127.0.0.1 (*)
#local_port: 9153
#redirect ALL DNS queries in DNSCrypt: No(*)
#Add. options: -e 4096 -S -m 0


### 4. Setting ipset using unblock_update.sh script
#
echo 'setting ipset'
#
/etc/storage/unblock/unblock_ipset.sh
echo 'ipset is set'
sleep 3
#
echo 'configuring 
resolv.dnsmasq
unblock.dnsmasq'
/etc/storage/unblock/unblock_update.sh
echo 'resolv-unblock.dnsmasqs is configured'
sleep 3


### 5. iptables. redirect all unblock list sites traffic in TOR. Router`s IP: 192.168.1.1'
#
echo 'iptables configuring. Router`s IP: 192.168.1.1'
#
echo '
### TOR
iptables -t nat -I PREROUTING -i br0 -p tcp -m set --match-set unblock dst -j REDIRECT --to-ports 9040
#iptables -t nat -A PREROUTING -i br0 -p tcp -m set --match-set unblock dst -j REDIRECT --to-port 9141
# Redirect DNS
iptables -t nat -I PREROUTING -i br0 -p udp --dport 53 -j DNAT --to 192.168.1.1
iptables -t nat -I PREROUTING -i br0 -p tcp --dport 53 -j DNAT --to 192.168.1.1
' >> /etc/storage/post_iptables_script.sh
echo 'iptables configuring is done'


### 6. adding additional dsnmasq file
#
echo 'adding additional dsnmasq'
#
echo '
### TOR
#If dnscrypt-proxy is enabled
conf-file=/etc/storage/unblock/resolv.dnsmasq
#
conf-file=/etc/storage/unblock/unblock.dnsmasq
server=8.8.8.8

' >> /etc/storage/dnsmasq/dnsmasq.conf
echo 'additional dsnmasq is added'


### 7. cron. uses user's name. Administration - Services. Turn ON 'Services Cron (scheduler)'. maxwell is used
#
echo 'adding task in crontab. User: maxwell'
#
echo '00 06 * * * maxwell /etc/storage/unblock/unblock_ipset.sh' >> /etc/storage/cron/crontabs/maxwell
echo 'task is added'


sleep 3
echo 'Finish. 
Rebooting'


### 8. reboot router
#
reboot
