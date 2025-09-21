#!/bin/bash

DEFAULT_BANDWIDTH="1mbit"
DEFAULT_INTERFACE="$(ip route | grep default | awk '{print $5}' | head -1)"

BANDWIDTH="${BANDWIDTH}"
INTERFACE="${INTERFACE}"

# setup
if [ -z "$BANDWIDTH" ]; then
    BANDWIDTH=$DEFAULT_BANDWIDTH
    echo "No BANDWIDTH specified, using default: $BANDWIDTH"
else
    echo "Using specified BANDWIDTH: $BANDWIDTH"
fi

if [ -z "$INTERFACE" ]; then
    INTERFACE=$DEFAULT_INTERFACE
    echo "No INTERFACE specified, using default: $INTERFACE"
else
    echo "Using specified INTERFACE: $INTERFACE"
fi

# clear existing rules
echo "Clearing existing tc rules on $INTERFACE..."
tc qdisc del dev $INTERFACE root 2>/dev/null

# apply new rules
echo "Applying new tc rules on $INTERFACE with bandwidth $BANDWIDTH..."
tc qdisc add dev $INTERFACE handle 1: root htb default 11
tc class add dev $INTERFACE parent 1: classid 1:1 htb rate $BANDWIDTH
tc class add dev $INTERFACE parent 1:1 classid 1:11 htb rate $BANDWIDTH
tc qdisc add dev $INTERFACE parent 1:11 handle 10: netem delay 10ms


# apply rules at server
ssh -o "StrictHostKeyChecking=no" -i ${CONFIG_PATH} ${CONFIG_USERNAME}@${CONFIG_HOSTS} "\
    sudo tc qdisc del dev $INTERFACE root 2>/dev/null; \
    sudo tc qdisc add dev $INTERFACE handle 1: root htb default 11; \
    sudo tc class add dev $INTERFACE parent 1: classid 1:1 htb rate $BANDWIDTH; \
    sudo tc class add dev $INTERFACE parent 1:1 classid 1:11 htb rate $BANDWIDTH; \
    sudo tc qdisc add dev $INTERFACE parent 1:11 handle 10: netem delay 10ms"