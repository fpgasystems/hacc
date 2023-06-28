#!/bin/bash

CLI_PATH=$1
MAX_DEVICES=$2
device_index=$3

vivado_devices=0
for ((i=1; i<=$MAX_DEVICES; i++)); do
    workflow=$($CLI_PATH/get/workflow -d $i)
    workflow=$(echo "$workflow" $i | cut -d' ' -f2 | sed '/^\s*$/d')
    if [ "$workflow" = "vivado" ] && [ "$i" -ne $device_index ]; then
        ((vivado_devices++))
    fi 
done

echo $vivado_devices