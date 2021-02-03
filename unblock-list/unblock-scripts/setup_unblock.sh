#!/bin/sh

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


echo Finish.
