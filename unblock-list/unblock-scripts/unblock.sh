#!/bin/sh

#unblock_Setup
echo Download List
wget -q -O /etc/storage/unblock/unblock.txt https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock.txt


echo Download scripts
echo downloading unblock_ipset.sh
wget -q -O /etc/storage/unblock/unblock_ipset.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_ipset.sh
chmod +x /etc/storage/unblock/unblock_ipset.sh

echo downloading unblock_update.sh
wget -q -O /etc/storage/unblock/unblock_update.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_update.sh
chmod +x /etc/storage/unblock/unblock_update.sh


echo Finish.
