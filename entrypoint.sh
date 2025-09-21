#!/bin/bash

# start microsocks
echo "[+] Starting microsocks..."
source ./microsocks.sh

# start ssh
echo "[+] Starting SSH..."
source ./ssh.sh

# start qos if BANDWIDTH is set
if [ ! -z "$BANDWIDTH" ]; then
    echo "[+] BANDWIDTH is set to $BANDWIDTH, starting qos..."
    source ./qos.sh
else
    echo "[+] BANDWIDTH is not set, skipping qos..."
fi



echo "both services started!"
tail -f /dev/null