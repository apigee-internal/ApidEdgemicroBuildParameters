#!/bin/bash
echo -e "apigeesync_consumer_key: $APIGEESYNC_CONSUMER_KEY
apigeesync_consumer_secret: $APIGEESYNC_CONSUMER_SECRET
apigeesync_bootstrap_id: $APIGEESYNC_BOOTSTRAP_ID" >> /demo/config/apid_config.yaml

cd /demo
./apid &
edgemicro start -e edgexdemo1 -o prod -k b1e714bc0222839d9d1a7879ceae5f4206b3d399025717b01fb2a21e567acf78 -s 1a6eb9b51e00015b8789bb527b079e4cc9c57b2bc470a81035eca969240721a4 &
