#!/bin/sh

#unblock_Setup_Start_Update
echo Resolve provider-DNS_inbuild dnscrypt-proxy is enabled_. copy previously created nameservers
cat /dev/null > /etc/storage/unblock/resolv.dnsmasq
while read line || [ -n "$line" ]; do
  [ -z "$line" ] && continue
  [ "${line:0:1}" = "#" ] && continue
  #
  varIP=$(echo $line | awk '{print $2}')
  echo $varIP | grep -Eq '127.0.0.1' && continue
  echo "server=$varIP" >> /etc/storage/unblock/resolv.dnsmasq
done < /etc/resolv.conf

echo Download List
wget -q -O /etc/storage/unblock/unblock.txt https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock.txt

echo Clean ipset before update
ipset flush unblock

echo Generating dnsmasq-unblock-conf
cat /dev/null > /etc/storage/unblock/unblock.dnsmasq
while read line || [ -n "$line" ]; do
  [ -z "$line" ] && continue
  [ "${line:0:1}" = "#" ] && continue
  #
  echo $line | grep -Eq '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' && continue
  #
  echo "ipset=/$line/unblock" >> /etc/storage/unblock/unblock.dnsmasq
  echo "server=/$line/127.0.0.1#9153" >> /etc/storage/unblock/unblock.dnsmasq
done < /etc/storage/unblock/unblock.txt

echo Download scripts
echo downloading unblock_ipset.sh
wget -q -O /etc/storage/unblock/unblock_ipset.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_ipset.sh
chmod +x /etc/storage/unblock/unblock_ipset.sh

echo setting-updating ipset
restart_dhcpd
sleep 3
/etc/storage/unblock/unblock_ipset.sh &
