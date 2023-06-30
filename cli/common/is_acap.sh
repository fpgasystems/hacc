#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#constants
ACAP_SERVERS_LIST="$CLI_PATH/constants/ACAP_SERVERS_LIST"

#check for acap
acap="0"
if (grep -q "^$hostname$" $ACAP_SERVERS_LIST); then
    acap="1"
fi

#output
echo $acap