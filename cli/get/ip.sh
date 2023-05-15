#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

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

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on multiple Xilinx devices
if [[ -z $(lspci | grep Xilinx) ]]; then
    multiple_devices=""
    echo "No Xilinx device found."
    echo ""
    exit
elif [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
    #servers with only one FPGA (i.e., alveo-u55c-01)
    multiple_devices="0"
elif [[ $(lspci | grep Xilinx | wc -l) -gt 2 ]]; then
    #servers with eight FPGAs (i.e., alveo-u280)
    multiple_devices="1"
else
    echo "Unexpected number of Xilinx devices."
    echo ""
    exit
fi

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    #get mellanox name
    mellanox_name=$(nmcli dev | grep mellanox-0 | awk '{print $1}')
    #print mellanox information
    echo ""
    #ip addr show $mellanox_name
    #ip_mellanox=$(ip addr show $mellanox_name | awk '/inet / {print $2}' | tr '\n' ' ' | sed 's/ *$//' | awk '{print $0, "(" $NF ")"}')
    #ip_mellanox=$(ip addr show $mellanox_name | awk '/inet / {print $2}' | tr '\n' ' ' | sed 's/ *$//' | awk '{getline mac < "/sys/class/net/$mellanox_name/address"; print $0, "(" mac ")"}')
    ip_mellanox=$(ip addr show $mellanox_name | awk '/inet / {print $2}' | awk -F/ '{print $1}')
    mac_mellanox=$(ip addr show $mellanox_name | grep -oE 'link/ether [^ ]+' | awk '{print toupper($2)}')
    echo "$hostname-mellanox-0 ($mellanox_name): $ip_mellanox ($mac_mellanox)"
    echo ""
    #print devices information
    for device in 0 1 2 3; do
        ip=$(/opt/cli/get/get_device_param $device IP)
        if [ -n "$ip" ]; then
            mac=$(/opt/cli/get/get_device_param $device MAC)
            device_type=$(/opt/cli/get/get_device_param $device device_type)
            add_0=$(split_addresses $ip $mac 0)
            add_1=$(split_addresses $ip $mac 1)
            name="$hostname-$device_type-$device"
            name_length=$(( ${#name} + 1 ))
            echo "$name: $add_0"
            printf "%-${name_length}s %s\n" "" "$add_1"
        fi
    done
    echo ""


    #device_0    
    #device=0
    #ip=$(/opt/cli/get/get_device_param $device IP)
    #if [ -n "$ip" ]; then
    #    mac=$(/opt/cli/get/get_device_param $device MAC)
    #    device_type=$(/opt/cli/get/get_device_param $device device_type)
    #    #split ip
    #    add_0=$(split_addresses $ip $mac 0)
    #    add_1=$(split_addresses $ip $mac 1)
    #    name="$hostname-$device_type-$device"
    #    name_length=$(( ${#name} + 1 ))
    #    echo "$name: $add_0"
    #    printf "%-${name_length}s %s\n" "" "$add_1"
    #fi


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

fi

