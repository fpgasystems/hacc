#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#inputs (./examine 0 root_port)
#id=$1
#parameter=$2

#get hostname
#url="${HOSTNAME}"
#hostname="${url%%.*}"

#constants
STR_LENGTH=20

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

#run xbutil examine
echo ""
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

#device_1
id_1=$(/opt/cli/get/get_device_param 1 id)
upstream_port_1=$(/opt/cli/get/get_device_param 1 upstream_port)
device_type_1=$(/opt/cli/get/get_device_param 1 device_type)
device_name_1=$(/opt/cli/get/get_device_param 1 device_name)
serial_number_1=$(/opt/cli/get/get_device_param 1 serial_number)
ip_1=$(/opt/cli/get/get_device_param 1 IP)
mac_1=$(/opt/cli/get/get_device_param 1 MAC)

#device_2
id_2=$(/opt/cli/get/get_device_param 2 id)
upstream_port_2=$(/opt/cli/get/get_device_param 2 upstream_port)
device_type_2=$(/opt/cli/get/get_device_param 2 device_type)
device_name_2=$(/opt/cli/get/get_device_param 2 device_name)
serial_number_2=$(/opt/cli/get/get_device_param 2 serial_number)
ip_2=$(/opt/cli/get/get_device_param 2 IP)
mac_2=$(/opt/cli/get/get_device_param 2 MAC)

#device_3
id_3=$(/opt/cli/get/get_device_param 3 id)
upstream_port_3=$(/opt/cli/get/get_device_param 3 upstream_port)
device_type_3=$(/opt/cli/get/get_device_param 3 device_type)
device_name_3=$(/opt/cli/get/get_device_param 3 device_name)
serial_number_3=$(/opt/cli/get/get_device_param 3 serial_number)
ip_3=$(/opt/cli/get/get_device_param 3 IP)
mac_3=$(/opt/cli/get/get_device_param 3 MAC)

echo "${bold}Device Index : BDF (Upstream port) : Device Type (Name)   : Serial Number : Networking${normal}"
echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"

#device_0
if [ -n "$id_0" ]; then  
  #adjust length
  aux="$device_type_0 ($device_name_0)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_0 $mac_0 0)
  add_1=$(split_addresses $ip_0 $mac_0 1)

  echo "$id_0            : $upstream_port_0             : $aux : $serial_number_0 : $add_0"
  echo "                                                                            $add_1"
fi

#device_1
if [ -n "$id_1" ]; then
  #adjust length
  aux="$device_type_0 ($device_name_0)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_1 $mac_1 0)
  add_1=$(split_addresses $ip_1 $mac_1 1)
  echo "$id_1            : $upstream_port_1             : $device_type_1 ($device_name_1) : $serial_number_1 : $add_0"
  echo "                                                                            $add_1"
fi

#device_2 (acap)
if [ -n "$id_2" ]; then
  #adjust length
  aux="$device_type_0 ($device_name_0)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_2 $mac_2 0)
  add_1=$(split_addresses $ip_2 $mac_2 1)
  echo "$id_2            : $upstream_port_2             : $device_type_2 ($device_name_2)    : $serial_number_2 : $add_0"
  echo "                                                                            $add_1"
fi

#device_3 (acap)
if [ -n "$id_3" ]; then
  #adjust length
  aux="$device_type_0 ($device_name_0)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_3 $mac_3 0)
  add_1=$(split_addresses $ip_3 $mac_3 1)
  echo "$id_3            : $upstream_port_3             : $device_type_3 ($device_name_3)    : $serial_number_3 : $add_0"
  echo "                                                                            $add_1"
fi

echo ""