#!/bin/bash

MICROSOCKS_QUIET="${MICROSOCKS_QUIET}"

# execute the microsocks-*.sh script
source ./microsocks-user.sh
source ./microsocks-net.sh

echo " [-] Configuring microsocks extra args..."

EXTRAARGS=""
if [ "$MICROSOCKS_QUIET" == "true" ]; then
    echo "      MICROSOCKS_QUIET is set!"
    EXTRAARGS="${EXTRAARGS} -q"
else
    echo "      MICROSOCKS_QUIET is not set!"
fi

echo "auth args: ${AUTHARGS}"
echo "net args: ${NETARGS}"
echo "extra args: ${EXTRAARGS}"

echo final args: ${AUTHARGS} ${NETARGS} ${EXTRAARGS}

# start microsocks
microsocks ${AUTHARGS} ${NETARGS} ${EXTRAARGS} &
echo "[+] microsocks started!"
