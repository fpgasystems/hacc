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
DATABASE="/opt/hacc/devices"

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

echo "${bold}Device Index : Upstream port (BFD) : Device Type (Name)   : Serial Number : Networking${normal}"
echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"

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
upstream_port_1=$(echo "$device_0" | awk '{print $2}')
root_port_0=$(echo "$device_0" | awk '{print $3}')
LinkCtl_0=$(echo "$device_0" | awk '{print $4}')

if [[ $upstream_port_1 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
  echo ""
  echo "Please, update $DATABASE according to your infrastructure."
  echo ""
  exit
fi

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

#device_4
id_4=$(/opt/cli/get/get_device_param 4 id)
upstream_port_4=$(/opt/cli/get/get_device_param 4 upstream_port)
device_type_4=$(/opt/cli/get/get_device_param 4 device_type)
device_name_4=$(/opt/cli/get/get_device_param 4 device_name)
serial_number_4=$(/opt/cli/get/get_device_param 4 serial_number)
ip_4=$(/opt/cli/get/get_device_param 4 IP)
mac_4=$(/opt/cli/get/get_device_param 4 MAC)

#echo "${bold}Device Index : BDF (Upstream port) : Device Type (Name)   : Serial Number : Networking${normal}"
#echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"

#device_1
if [ -n "$id_1" ]; then  
  #get bdf
  bdf_1="${upstream_port_1::-1}1"
  #adjust length
  aux="$device_type_1 ($device_name_1)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_1 $mac_1 0)
  add_1=$(split_addresses $ip_1 $mac_1 1)

  #echo "$id_1            : $upstream_port_1             : $aux : $serial_number_1 : $add_0"
  echo "$id_1            : $upstream_port_1 ($bdf_1)   : $aux : $serial_number_1 : $add_0"
  echo "                                                                            $add_1"
fi

#device_2
if [ -n "$id_2" ]; then
  #get bdf
  bdf_2="${upstream_port_2::-1}1"
  #adjust length
  aux="$device_type_1 ($device_name_1)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_2 $mac_2 0)
  add_1=$(split_addresses $ip_2 $mac_2 1)
  #echo "$id_2            : $upstream_port_2             : $device_type_2 ($device_name_2) : $serial_number_2 : $add_0"
  echo "$id_2            : $upstream_port_2 ($bdf_2)   : $device_type_2 ($device_name_2) : $serial_number_2 : $add_0"
  echo "                                                                            $add_1"
fi

#device_3 (acap)
if [ -n "$id_3" ]; then
  #get bdf
  bdf_3="${upstream_port_3::-1}1"
  #adjust length
  aux="$device_type_1 ($device_name_1)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_3 $mac_3 0)
  add_1=$(split_addresses $ip_3 $mac_3 1)
  #echo "$id_3            : $upstream_port_3             : $device_type_3 ($device_name_3)    : $serial_number_3 : $add_0"
  echo "$id_3            : $upstream_port_3 ($bdf_3)   : $device_type_3 ($device_name_3)    : $serial_number_3 : $add_0"
  echo "                                                                            $add_1"
fi

#device_4 (acap)
if [ -n "$id_4" ]; then
  #get bdf
  bdf_4="${upstream_port_4::-1}1"
  #adjust length
  aux="$device_type_1 ($device_name_1)"
  diff=$(( $STR_LENGTH - ${#aux} ))
  aux="$aux$(printf '%*s' $diff)"
  #split ip
  add_0=$(split_addresses $ip_4 $mac_4 0)
  add_1=$(split_addresses $ip_4 $mac_4 1)
  #echo "$id_4            : $upstream_port_4             : $device_type_4 ($device_name_4)    : $serial_number_4 : $add_0"
  echo "$id_4            : $upstream_port_4 ($bdf_4)   : $device_type_4 ($device_name_4)    : $serial_number_4 : $add_0"
  echo "                                                                            $add_1"
fi

echo ""