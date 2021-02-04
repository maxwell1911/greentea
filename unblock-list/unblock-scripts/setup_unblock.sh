#!/bin/sh

### 1. init ipset
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

### comments.some scripts to remember
# /etc/storage/unblock/unblock.sh #main script.setup-start-update
# /etc/storage/unblock/unblock_update.sh #main script.start-Update
# ipset list unblock #check unblock-ipset array

' >> /etc/storage/start_script.sh


### 2. tor setting
#
cat /dev/null > /etc/storage/tor/torrc
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


### 3. dnscrypt-proxy
#
#dnscrypt-proxy
###Отредактировать через веб-интерфейс маршрутизатора — "Администрирование"-->"Сервисы". Вкл "Сервис DNSCrypt proxy?". После редактирования нажмите «Применить».:
#resolver: cisco
#local_ip_address: 127.0.0.1 (*)
#local_port: 9153
#redirect ALL DNS queries in DNSCrypt: No(*)
#Add. options: -e 4096 -S -m 0


### 4. 


echo Finish.
