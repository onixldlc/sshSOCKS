#!/bin/bash

CONFIG_PATH="${CONFIG_PATH}"
CONFIG_BASE64="${CONFIG_BASE64}"

CONFIG_USERNAME="${CONFIG_USERNAME}"
CONFIG_HOSTS="${CONFIG_HOSTS}"


# check if username and hosts are set
if [ -z "$CONFIG_USERNAME" ] || [ -z "$CONFIG_HOSTS" ]; then
    echo "No username or hosts specified!"
    echo "exiting..."
    exit 1
else
    echo "Username and hosts specified!"
    echo "using '${CONFIG_USERNAME}@${CONFIG_HOSTS}' as target ..."
fi


#setup ssh key
if [ -z "$CONFIG_BASE64" ]; then
    echo "No config file specified!"
else
    echo "Config file specified!"
    echo "$CONFIG_BASE64" | base64 -d > /etc/ssh/ssh.key
fi

if [ -z "$CONFIG_PATH" ]; then
    echo "No config file specified! using default config path!"
    CONFIG_PATH="/etc/ssh/ssh.key"
else
    echo "Config file specified!"
fi

if [ "$CONFIG_PATH" == "/etc/ssh/ssh.key" ]; then
    echo "Using default config path!"
else
    echo "Using custom config path!"
fi
echo "config file: [$CONFIG_PATH]" 


if [ -f "$CONFIG_PATH" ]; then
    cp "$CONFIG_PATH" /etc/ssh/ssh.key
else
    echo "No config file found at [$CONFIG_PATH] !"
    exit 1
fi

chmod 600 /etc/ssh/ssh.key

ssh -D 1079 -C -N -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "ServerAliveInterval=60" -i /etc/ssh/ssh.key ${CONFIG_USERNAME}@${CONFIG_HOSTS} &
echo "[+] ssh to ${CONFIG_USERNAME}@${CONFIG_HOSTS} started!"

export ALL_PROXY="socks5h://127.0.0.1:1079"