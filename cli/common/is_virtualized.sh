#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#constants
VIRTUALIZED_SERVERS_LIST="$CLI_PATH/constants/VIRTUALIZED_SERVERS_LIST"

#check for virtualized
virtualized="0"
if (grep -q "^$hostname$" $VIRTUALIZED_SERVERS_LIST); then
    virtualized="1"
fi

#output
echo $virtualized