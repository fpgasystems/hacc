#!/bin/bash

CLI_PATH=$1
hostname=$2

# Declare global variables
declare -g servers_family_list_string=""

#get booked machines
echo ""
servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2)
echo ""

#convert string to an array
servers=($servers)

#we only show likely servers (i.e., alveo-u55c)
server_family="${hostname%???}"

#build servers_family_list
servers_family_list=()
for i in "${servers[@]}"
do
    if [[ $i == $server_family* ]] && [[ $i != $hostname ]]; then
        #append the matching element to the array
        servers_family_list+=("$i") 
    fi
done

#convert to string and remove the leading delimiter (:2)
servers_family_list_string=$(printf ", %s" "${servers_family_list[@]}")
servers_family_list_string=${servers_family_list_string:2}

#deployment dialog
if [ -n "$servers_family_list_string" ]; then
    echo "${bold}Where do you want to deploy your binary?${normal}"
    echo ""
    echo "1) Only this server ($hostname)"
    echo "2) All servers I have booked ($hostname, $servers_family_list_string)"
    while true; do
	    read -p "" deploy_option
        case $deploy_option in
            "1") 
                servers_family_list=()
                break
                ;;
            "2") 
                break
                ;;
        esac
    done
    echo ""
fi

# Return the values of project_found and project_name
servers_family_list_string=$(printf ", %s" "${servers_family_list[@]}")