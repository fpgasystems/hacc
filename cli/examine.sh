#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#inputs (./examine 0 root_port)
#id=$1
#parameter=$2

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


/opt/xilinx/xrt/bin/xbutil examine

echo ""
echo ""

#device_0
id_0=$(/opt/cli/get/get_device_param 0 id)
upstream_port_0=$(/opt/cli/get/get_device_param 0 upstream_port)
device_type_0=$(/opt/cli/get/get_device_param 0 device_type)
device_name_0=$(/opt/cli/get/get_device_param 0 device_name)
serial_number_0=$(/opt/cli/get/get_device_param 0 serial_number)
ip_0=$(/opt/cli/get/get_device_param 0 IP)
mac_0=$(/opt/cli/get/get_device_param 0 MAC)

echo "Device Index : BFD (Upstream port) : Device Type (Name)   : Serial Number : Networking"
echo "-------------------------------------------------------------------------------------------------------------"

if [ -n "$id_0" ]; then
  add_0=$(split_addresses $ip_0 $mac_0 0)
  add_1=$(split_addresses $ip_0 $mac_0 1)
  echo "$id_0            : $upstream_port_0             : $device_type_0 ($device_name_0) : $serial_number_0 : $add_0"
  echo "                                                                            $add_1"
fi
