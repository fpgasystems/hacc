#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#inputs
read -a flags <<< "$@"

#helper functions
split_addresses (){
  #input parameters
  str_ip=$1
  str_mac=$2
  aux=$3
  #save the current IFS
  OLDIFS=$IFS
  #set the IFS to / to split the string at each /
  IFS="/"
  #read the two parts of the string into variables
  read ip0 ip1 <<< "$str_ip"
  read mac0 mac1 <<< "$str_mac"
  #reset the IFS to its original value
  IFS=$OLDIFS
  #print the two parts of the string
  if [[ "$aux" == "0" ]]; then
    echo "$ip0 ($mac0)"
  else
    echo "$ip1 ($mac1)"
  fi
}

# Check if the DEVICES_LIST exists
if [[ ! -f "$DEVICES_LIST" ]]; then
  echo ""
  echo "Please, update $DEVICES_LIST according to your infrastructure."
  echo ""
  exit 1
fi

#the file exists - check its contents by evaluating first row (device_0)
device_0=$(head -n 1 "$DEVICES_LIST")

#extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
upstream_port_0=$(echo "$device_0" | awk '{print $2}')
root_port_0=$(echo "$device_0" | awk '{print $3}')
LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

#check on non-edited contents
if [[ $upstream_port_0 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
  echo ""
  echo "Please, update $DEVICES_LIST according to your infrastructure."
  echo ""
  exit
fi

#check on multiple Xilinx devices
multiple_devices=""
devices=$(wc -l < $DEVICES_LIST)
if [ -s $DEVICES_LIST ]; then
    if [ "$devices" -eq 1 ]; then
        multiple_devices="0"
    else
        multiple_devices="1"
    fi
else
    echo ""
    echo "Please, update $DEVICES_LIST according to your infrastructure."
    echo ""
    exit
fi

echo ""

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #print devices information
    for device_index in 1 2 3 4; do #0 1 2 3
        name=$($CLI_PATH/get/get_fpga_device_param $device_index serial_number)
        if [ -n "$name" ]; then
            #type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
            echo "$device_index: $name" #"$device_index: $type - $name"
        fi
    done
    echo ""
else
    #find flags and values
    for (( i=0; i<${#flags[@]}; i++ ))
    do
        if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
            device_found="1"
            device_idx=$(($i+1))
            device_index=${flags[$device_idx]}
        fi  
    done
    #forbidden combinations
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))); then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #device_index should be between {0 .. MAX_DEVICES - 1}
    #MAX_DEVICES=$(($MAX_DEVICES-1))
    if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
        $CLI_PATH/sgutil get device -h
        exit
    fi
    #print
    name=$($CLI_PATH/get/get_fpga_device_param $device_index serial_number)
    #type=$($CLI_PATH/get/get_fpga_device_param $device_index device_type)
    echo "$device_index: $name" #"$device_index: $type - $name"
    echo ""
fi