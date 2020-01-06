#!/bin/sh

#until ADDRS=$(dig +short google.com @localhost -p 9153) && [ -n "$ADDRS" ] > /dev/null 2>&1; do sleep 5; done
until ADDRS=$(nslookup google.com localhost:9153 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v '127.0.0.1') && [ -n "$ADDRS" ] > /dev/null 2>&1; do sleep 5; done
#
while read line || [ -n "$line" ]; do
#
  [ -z "$line" ] && continue
  [ "${line:0:1}" = "#" ] && continue
#
  addr=$(echo $line | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
  if [ ! -z "$addr" ]; then
    ipset -exist add unblock $addr
    continue
  fi
#
  cidr=$(echo $line | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}')
  if [ ! -z "$cidr" ]; then
    ipset -exist add unblock $cidr
    continue
  fi
#    
  range=$(echo $line | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
  if [ ! -z "$range" ]; then
    ipset -exist add unblock $range
    continue
  fi
#  
  #dig +short $line @localhost -p 9153 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '{system("ipset -exist add unblock "$1)}'
  nslookup $line localhost:9153 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v '127.0.0.1' | awk '{system("ipset -exist add unblock "$1)}'
#
done < /etc/storage/unblock/unblock.txt
