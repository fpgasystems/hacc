#!/bin/bash

#CLI_PATH=$1
#hostname=$2

servers_family_list_string=$1

# Declare global variables
declare -g deploy_option="0"

#get device index
if [ -n "$servers_family_list_string" ]; then
    while true; do
        read -p "" deploy_option
        case $deploy_option in
            "0") 
                #servers_family_list=()
                break
                ;;
            "1") 
                break
                ;;
        esac
    done
    echo ""
fi

#return the values of device_found and device_index
#echo $servers_family_list
echo $deploy_option
#echo "${servers_family_list[@]}"