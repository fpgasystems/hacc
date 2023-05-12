#!/bin/bash

#usage: get_device_ip enp35s0f0 1
#result: it gets the IP assigned to enp35s0f0 (typically a Mellanox card) and increases the last octet by one

mellanox_interface_name=$1
increment=$2

if [ "$#" -ne 2 ] ; then
    echo ""
    echo "$0: exactly 2 arguments expected. Example: ./get_device_ip enp35s0f0 1"
    exit
fi

# Get the current IP address
IP_ADDRESS=$(ip addr show $mellanox_interface_name | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

# Split the IP address into octets
OCTETS=(${IP_ADDRESS//./ })

# Convert the last octet to a decimal number and increment by increment
LAST_OCTET=$((10#${OCTETS[3]}+$increment))

# Combine the octets back into an IP address
NEW_IP_ADDRESS="${OCTETS[0]}.${OCTETS[1]}.${OCTETS[2]}.$LAST_OCTET"

# Print the new IP address
echo $NEW_IP_ADDRESS