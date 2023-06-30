#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#constants
GPU_SERVERS_LIST="$CLI_PATH/constants/GPU_SERVERS_LIST"

#check for gpu
gpu="0"
if (grep -q "^$hostname$" $GPU_SERVERS_LIST); then
    gpu="1"
fi

#output
echo $gpu