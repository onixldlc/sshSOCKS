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





# #!/bin/bash

# BANDWIDTH="5mbit"   # Set your desired bandwidth limit here
# BURST="32kb"        # Set burst size
# CBURST="64kb"        # Set burst size
# LATENCY="50ms"      # Set target latency
# QUEUE_SIZE="1024"  # Set queue size
# INTERFACE="eth0"    # Network interface to apply the rules on

# # Check if script is run as root
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run as root"
#   exit 1
# fi

# # Remove any existing rules
# tc qdisc del dev $INTERFACE root 2>/dev/null

# # Create hierarchical traffic control with multiple classes and prioritization
# setup_tc() {

# # Create HTB root with bandwidth limit
# tc qdisc add dev $INTERFACE root handle 1: htb default 10

# # Add class with bandwidth limit
# tc class add dev $INTERFACE parent 1: classid 1:10 htb rate $BANDWIDTH ceil $BANDWIDTH

# # Add RED qdisc with packet dropping
# # min = start considering drops, max = definitely drop, probability = drop chance
# tc qdisc add dev $INTERFACE parent 1:10 handle 10: red \
#     min 500 \
#     max 1000 \
#     probability 0.1 \
#     avpkt 100 \
#     burst 20
# }

# # Remove TC rules
# remove_tc() {
#   tc qdisc del dev $INTERFACE root 2>/dev/null
#   echo "Traffic control rules removed."
# }

# # Check if any parameter is provided
# if [ "$1" == "remove" ]; then
#   remove_tc
# else
#   setup_tc
#   echo "ISP-like traffic control applied to eth0."
#   tc qdisc show dev $INTERFACE
#   tc class show dev $INTERFACE
# fi