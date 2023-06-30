#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#acap
acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
if [ "$acap" = "1" ]; then
    acap="acap_"
else
    acap=""
fi
#cpu
cpu=$($CLI_PATH/common/is_cpu $CLI_PATH $hostname)
if [ "$cpu" = "1" ]; then
    cpu="cpu_"
else
    cpu=""
fi
#fpga
fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
if [ "$fpga" = "1" ]; then
    fpga="fpga_"
else
    fpga=""
fi
#gpu
gpu=$($CLI_PATH/common/is_gpu $CLI_PATH $hostname)
if [ "$gpu" = "1" ]; then
    gpu="gpu_"
else
    gpu=""
fi
#virtualized
virtualized=$($CLI_PATH/common/is_virtualized $CLI_PATH $hostname)
if [ "$virtualized" = "1" ]; then
    virtualized="virtualized_"
else
    virtualized=""
fi

#server type
#server_type=$acap"_"$cpu"_"$fpga"_"$gpu"_"$virtualized
server_type=$acap$cpu$fpga$gpu$virtualized

#remove characters
server_type="${server_type/#_/}"
server_type=$(echo "$server_type" | sed 's/__/_/g')
server_type="${server_type/%_/}"

#output
echo $server_type