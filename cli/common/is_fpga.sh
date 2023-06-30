#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#constants
FPGA_SERVERS_LIST="$CLI_PATH/constants/FPGA_SERVERS_LIST"

#check for fpga
fpga="0"
if (grep -q "^$hostname$" $FPGA_SERVERS_LIST); then
    fpga="1"
fi

#output
echo $fpga