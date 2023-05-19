#!/bin/bash

#the file exists - check its contents by evaluating first row (device_0)
device_0=$(head -n 1 "$DATABASE")

#extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
upstream_port_0=$(echo "$device_0" | awk '{print $2}')
root_port_0=$(echo "$device_0" | awk '{print $3}')
LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

#check on non-edited contents
if [[ $upstream_port_0 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
  echo ""
  echo "Please, update $DATABASE according to your infrastructure."
  echo ""
  exit
fi

#check on multiple Xilinx devices
multiple_devices=""
devices=$(wc -l < $DATABASE)

echo $devices