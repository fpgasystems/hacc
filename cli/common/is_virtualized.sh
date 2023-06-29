#!/bin/bash

#get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

#inputs
CLI_PATH=$1
hostname=$2

#constants
VIRTUALIZED_SERVERS_LIST="$CLI_PATH/constants/VIRTUALIZED_SERVERS_LIST"

virtualized="0"
if (grep -q "^$hostname$" $VIRTUALIZED_SERVERS_LIST); then
    virtualized="1"
fi
echo $virtualized

#chech if virtualized
#if [ "$hostname" = "alveo-u250-01" ] || [ "$hostname" = "alveo-u250-02" ] || [ "$hostname" = "alveo-u250-03" ] || [ "$hostname" = "alveo-u250-04" ] || [ "$hostname" = "alveo-u250-05" ] || [ "$hostname" = "alveo-u250-06" ] || [ "$hostname" = "alveo-u280-01" ] || [ "$hostname" = "alveo-u280-02" ] || [ "$hostname" = "alveo-u280-03" ] || [ "$hostname" = "alveo-u280-04" ] || [ "$hostname" = "versal-vck5000-01" ]; then
#    #virtualized environment
#    echo "true"
#else
#    echo "false"
#fi