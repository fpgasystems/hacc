#!/bin/bash

#inputs
CLI_PATH=$1
hostname=$2

#acap
acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
#cpu
cpu=$($CLI_PATH/common/is_cpu $CLI_PATH $hostname)
#fpga
fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
#gpu
gpu=$($CLI_PATH/common/is_gpu $CLI_PATH $hostname)
#virtualized
virtualized=$($CLI_PATH/common/virtualized $CLI_PATH $hostname)

#output
echo $acap"_"$cpu"_"$fpga"_"$gpu"_"$virtualized