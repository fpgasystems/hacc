#!/bin/bash

DATABASE="/opt/hacc/devices"

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_WORKDIR="/opt/cli"
MAX_DEVICES=4

#get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

split_addresses (){

  str_ip=$1
  str_mac=$2
  aux=$3

  # Save the current IFS
  OLDIFS=$IFS

  # Set the IFS to / to split the string at each /
  IFS="/"

  # Read the two parts of the string into variables
  read ip0 ip1 <<< "$str_ip"
  read mac0 mac1 <<< "$str_mac"

  # Reset the IFS to its original value
  IFS=$OLDIFS

  # Print the two parts of the string
  if [[ "$aux" == "0" ]]; then
    echo "$ip0 ($mac0)"
  else
    echo "$ip1 ($mac1)"
  fi

}

#inputs
read -a flags <<< "$@"

# Check if the DATABASE exists
if [[ ! -f "$DATABASE" ]]; then
  echo ""
  echo "Please, update $DATABASE according to your infrastructure."
  echo ""
  exit 1
fi

#the file exists - check its contents by evaluating first row (device_0)
device_0=$(head -n 1 "$DATABASE")

#extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
upstream_port_0=$(echo "$device_0" | awk '{print $2}')
root_port_0=$(echo "$device_0" | awk '{print $3}')
LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

#check on non-edited contents
if [[ $upstream_port_0 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
  echo ""
  echo "Please, update $DATABASE according to your infrastructure."
  echo ""
  exit
fi

#check on multiple Xilinx devices
multiple_devices=""
devices=$(wc -l < $DATABASE)
if [ -s $DATABASE ]; then
    if [ "$devices" -eq 1 ]; then
        multiple_devices="0"
    else
        multiple_devices="1"
    fi
else
    echo ""
    echo "Please, update $DATABASE according to your infrastructure."
    echo ""
    exit
fi

#if [[ -z $(lspci | grep Xilinx) ]]; then
#    multiple_devices=""
#    echo "No Xilinx device found."
#    echo ""
#    exit
#elif [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
#    #servers with only one FPGA (i.e., alveo-u55c-01)
#    multiple_devices="0"
#elif [[ $(lspci | grep Xilinx | wc -l) -gt 2 ]]; then
#    #servers with eight FPGAs (i.e., alveo-u280)
#    multiple_devices="1"
#else
#    echo "Unexpected number of Xilinx devices."
#    echo ""
#    exit
#fi

echo ""

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #print devices information
    for device_index in 0 1 2 3; do
        name=$($CLI_WORKDIR/get/get_device_param $device_index device_name)
        if [ -n "$name" ]; then
            #type=$($CLI_WORKDIR/get/get_device_param $device_index device_type)
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
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
        $CLI_WORKDIR/sgutil get device -h
        exit
    fi
    #device_index should be between {0 .. MAX_DEVICES - 1}
    MAX_DEVICES=$(($MAX_DEVICES-1))
    if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 0 ]]; then
        $CLI_WORKDIR/sgutil get device -h
        exit
    fi
    #print
    name=$($CLI_WORKDIR/get/get_device_param $device_index device_name)
    #type=$($CLI_WORKDIR/get/get_device_param $device_index device_type)
    echo "$device_index: $name" #"$device_index: $type - $name"
    echo ""
fi