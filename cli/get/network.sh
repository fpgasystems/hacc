#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

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

#inputs
read -a flags <<< "$@"

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
multiple_devices=$($CLI_PATH/common/get_multiple_devices $DEVICES_LIST)

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    echo ""
    #print devices information
    for device_index in $(seq 1 $MAX_DEVICES); do 
        ip=$(/opt/cli/get/get_fpga_device_param $device_index IP)
        if [ -n "$ip" ]; then
            mac=$(/opt/cli/get/get_fpga_device_param $device_index MAC)
            device_type=$(/opt/cli/get/get_fpga_device_param $device_index device_type)
            add_0=$(split_addresses $ip $mac 0)
            add_1=$(split_addresses $ip $mac 1)
            name="$device_index" 
            name_length=$(( ${#name} + 1 ))
            echo "$name: $add_0"
            printf "%-${name_length}s %s\n" "" "$add_1"
        fi
    done
    echo ""
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil get network -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil get network -h
        exit
    fi
    #print
    ip=$(/opt/cli/get/get_fpga_device_param $device_index IP)
    mac=$(/opt/cli/get/get_fpga_device_param $device_index MAC)
    device_type=$(/opt/cli/get/get_fpga_device_param $device_index device_type)
    add_0=$(split_addresses $ip $mac 0)
    add_1=$(split_addresses $ip $mac 1)
    name="$device_index"
    name_length=$(( ${#name} + 1 ))
    echo ""
    echo "$name: $add_0"
    printf "%-${name_length}s %s\n" "" "$add_1"
    echo ""
fi