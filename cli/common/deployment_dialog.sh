#!/bin/bash

CLI_PATH=$1
hostname=$2

#get device index
if [ -n "$servers_family_list_string" ]; then    
    #multiple choice
    #echo ""
    #echo "${bold}Please, choose your device:${normal}"
    #echo ""
    PS3=""
    select device_index in "${devices[@]}"; do
        if [[ -z $device_index ]]; then
            echo "" >&/dev/null
        else
            device_found="1"
            device_index=$REPLY #${device_index:0:1}
            break
        fi
    done
fi

#return the values of device_found and device_index
echo "$device_found"
echo "$device_index"