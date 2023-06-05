#!/bin/bash

DEVICES_LIST=$1

if [[ -f "$DEVICES_LIST" ]]; then
  # Print if the first fpga/acap is valid
  device_1=$(head -n 1 "$DEVICES_LIST")
  upstream_port_1=$(echo "$device_1" | awk '{print $2}') 
  if ! lspci | grep -qz $upstream_port_1; then
    exit
  fi
else
  #DEVICES_LIST does not exist
  exit
fi