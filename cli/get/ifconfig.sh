#!/bin/bash

#get mellanox name
mellanox_name=$(nmcli dev | grep mellanox-0 | awk '{print $1}')
ip_mellanox=$(ip addr show $mellanox_name | awk '/inet / {print $2}' | awk -F/ '{print $1}')
mac_mellanox=$(ip addr show $mellanox_name | grep -oE 'link/ether [^ ]+' | awk '{print toupper($2)}')

echo ""
echo "0: $ip_mellanox ($mac_mellanox)"
echo ""