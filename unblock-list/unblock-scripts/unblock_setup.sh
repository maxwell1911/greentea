#!/bin/sh

mkdir -p /etc/storage/unblock
wget -q -O /etc/storage/unblock/unblock_setup.sh https://raw.githubusercontent.com/Maximys717/greentea/master/unblock-list/unblock-scripts/unblock_setup.sh
chmod +x /etc/storage/unblock/unblock_setup.sh


### init ipset
echo '' >> /etc/storage/start_script.sh
echo '### TOR. Example - load ipset modules.' >> /etc/storage/start_script.sh
echo 'modprobe ip_set' >> /etc/storage/start_script.sh
echo 'modprobe ip_set_hash_ip' >> /etc/storage/start_script.sh
echo 'modprobe ip_set_hash_ip' >> /etc/storage/start_script.sh
echo 'modprobe ip_set_hash_net #main' >> /etc/storage/start_script.sh
echo 'modprobe ip_set_bitmap_ip' >> /etc/storage/start_script.sh
echo 'modprobe ip_set_list_set' >> /etc/storage/start_script.sh
echo 'modprobe xt_set #main' >> /etc/storage/start_script.sh
echo '' >> /etc/storage/start_script.sh
echo '### TOR. creating of unblock array' >> /etc/storage/start_script.sh
echo 'ipset create unblock hash:net #main' >> /etc/storage/start_script.sh
echo '' >> /etc/storage/start_script.sh
echo '' >> /etc/storage/start_script.sh

echo '### comments.some scripts to remember' >> /etc/storage/start_script.sh
echo '# /etc/storage/unblock/unblock.sh #main script.setup-start-update' >> /etc/storage/start_script.sh
echo '# /etc/storage/unblock/unblock_update.sh #main script.start-Update' >> /etc/storage/start_script.sh
echo '# ipset list unblock #check unblock-ipset array' >> /etc/storage/start_script.sh
echo '' >> /etc/storage/start_script.sh

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