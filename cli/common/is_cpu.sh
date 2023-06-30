#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#constants
CPU_SERVERS_LIST="$CLI_PATH/constants/CPU_SERVERS_LIST"

#check for cpu
cpu="0"
if (grep -q "^$hostname$" $CPU_SERVERS_LIST); then
    cpu="1"
fi

#output
echo $cpu