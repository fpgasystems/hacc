#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
XRT_PATH="/opt/xilinx/xrt"
HACC_PATH="/opt/hacc"
RECONF_DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
GPU_DEVICES_LIST="$HACC_PATH/devices_gpu"
STR_LENGTH=20

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

#run xbutil examine
echo ""
$XRT_PATH/bin/xbutil examine

echo ""

#reconfigurable devices
echo "${bold}Device Index : Upstream port (BFD) : Device Type (Name)   : Serial Number : Networking${normal}"
echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"
if [[ -f "$RECONF_DEVICES_LIST" ]]; then
  #the file exists - check its contents by evaluating first row (device_0)
  device_0=$(head -n 1 "$RECONF_DEVICES_LIST")
  #extract the second, third, and fourth columns (upstream_port, root_port, LinkCtl) using awk
  upstream_port_1=$(echo "$device_0" | awk '{print $2}')
  root_port_0=$(echo "$device_0" | awk '{print $3}')
  LinkCtl_0=$(echo "$device_0" | awk '{print $4}')
  #print if the information has been updated
  if [[ $upstream_port_1 == "xx:xx.x" || $root_port_0 == "xx:xx.x" || $LinkCtl_0 == "xx" ]]; then
    echo ""
    echo "Please, update $RECONF_DEVICES_LIST according to your infrastructure."
    echo ""
  else
    #get number of fpga and acap devices present
    MAX_RECONF_DEVICES=$(grep -E "fpga|acap" $RECONF_DEVICES_LIST | wc -l)
    #loop over reconfigurable devices
    for ((i=1; i<=$MAX_RECONF_DEVICES; i++)); do
      id=$(/opt/cli/get/get_device_param $i id)
      upstream_port=$(/opt/cli/get/get_device_param $i upstream_port)
      device_type=$(/opt/cli/get/get_device_param $i device_type)
      device_name=$(/opt/cli/get/get_device_param $i device_name)
      serial_number=$(/opt/cli/get/get_device_param $i serial_number)
      ip=$(/opt/cli/get/get_device_param $i IP)
      mac=$(/opt/cli/get/get_device_param $i MAC)
      #print table
      if [ -n "$id" ]; then  
        #get bdf
        bdf="${upstream_port::-1}1"
        #adjust length
        aux="$device_type ($device_name)"
        diff=$(( $STR_LENGTH - ${#aux} ))
        aux="$aux$(printf '%*s' $diff)"
        #split ip
        add_0=$(split_addresses $ip $mac 0)
        add_1=$(split_addresses $ip $mac 1)
        #print row
        echo "$id            : $upstream_port ($bdf)   : $aux : $serial_number : $add_0"
        echo "                                                                            $add_1"
      fi
    done
    echo ""
  fi
else
  #the file does not even exist
  echo ""
  echo "Please, update $RECONF_DEVICES_LIST according to your infrastructure."
  echo ""
fi