#!/bin/bash

MICROSOCKS_LISTEN_IP="${MICROSOCKS_LISTEN_IP}"
MICROSOCKS_WHITELIST="${MICROSOCKS_WHITELIST}"
MICROSOCKS_BINDIP="${MICROSOCKS_BINDIP}"
MICROSOCKS_PORT="${MICROSOCKS_PORT}"


echo " [-] Configuring microsocks network args..."
NETARGS=""


if [ -z "$MICROSOCKS_LISTEN_IP" ]; then
    echo "      MICROSOCKS_LISTEN_IP is not set!"
    NETARGS="${NETARGS}"
else
    echo "      MICROSOCKS_LISTEN_IP is set to ${MICROSOCKS_LISTEN_IP}"
    NETARGS="${NETARGS} -i ${MICROSOCKS_LISTEN_IP}"
fi
if [ -z "$MICROSOCKS_WHITELIST" ]; then
    echo "      MICROSOCKS_WHITELIST is not set!"
    NETARGS="${NETARGS}"
else
    echo "      MICROSOCKS_WHITELIST is set to ${MICROSOCKS_WHITELIST}"
    NETARGS="${NETARGS} -w ${MICROSOCKS_WHITELIST}"
fi
if [ -z "$MICROSOCKS_BINDIP" ]; then
    echo "      MICROSOCKS_BINDIP is not set!"
    NETARGS="${NETARGS}"
else
    echo "      MICROSOCKS_BINDIP is set to ${MICROSOCKS_BINDIP}"
    NETARGS="${NETARGS} -b ${MICROSOCKS_BINDIP}"
fi
if [ -z "$MICROSOCKS_PORT" ]; then
    echo "      MICROSOCKS_PORT is not set!"
    NETARGS="${NETARGS}"
else
    echo "      MICROSOCKS_PORT is set to ${MICROSOCKS_PORT}"
    NETARGS="${NETARGS} -p ${MICROSOCKS_PORT}"
fi
