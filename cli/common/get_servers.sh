#!/bin/bash

CLI_PATH=$1
hostname=$2

# Declare global variables
declare -g servers_family_list_string=""

#get booked machines
echo ""
  servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2)
  echo ""
  
  # Convert string to an array
  servers=($servers)
  
  # We only show likely servers (i.e., alveo-u55c)
  server_family="${hostname%???}"
  
  # Build servers_family_list
  servers_family_list=()
  for i in "${servers[@]}"
  do
      if [[ $i == $server_family* ]] && [[ $i != $hostname ]]; then
          # Append the matching element to the array
          servers_family_list+=("$i") 
      fi
  done
  
  # Return the array
  echo "${servers_family_list[@]}"