#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
XRT_PATH="/opt/xilinx/xrt"
HACC_PATH="/opt/hacc"
DEVICE_LIST_FPGA="$HACC_PATH/devices_reconfigurable"
DEVICE_LIST_GPU="$HACC_PATH/devices_gpu"
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

print_reconfigurable_devices_header (){
  echo "${bold}Device Index : Upstream port (BFD) : Device Type (Name)   : Serial Number : Networking${normal}"
  echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"
}

print_gpu_devices_header (){
  echo "${bold}Device Index : PCI BUS : Device Type (GPU ID) : Serial Number : Unique ID${normal}"
  echo "${bold}-------------------------------------------------------------------------------------------------------------${normal}"
}

#reconfigurable devices
if [[ -f "$DEVICE_LIST_FPGA" ]]; then
  #print if the first fpga/acap is valid
  device_1=$(head -n 1 "$DEVICE_LIST_FPGA")
  upstream_port_1=$(echo "$device_1" | awk '{print $2}')
  if [[ -n "$(lspci | grep $upstream_port_1)" ]]; then
    #run xbutil examine
    echo ""
    $XRT_PATH/bin/xbutil examine
    echo ""
    print_reconfigurable_devices_header
    #get number of fpga and acap devices present
    MAX_RECONF_DEVICES=$(grep -E "fpga|acap" $DEVICE_LIST_FPGA | wc -l)
    #loop over reconfigurable devices
    for ((i=1; i<=$MAX_RECONF_DEVICES; i++)); do
      id=$(/opt/cli/get/get_fpga_device_param $i id)
      #print table
      if [ -n "$id" ]; then  
        upstream_port=$(/opt/cli/get/get_fpga_device_param $i upstream_port)
        device_type=$(/opt/cli/get/get_fpga_device_param $i device_type)
        device_name=$(/opt/cli/get/get_fpga_device_param $i device_name)
        serial_number=$(/opt/cli/get/get_fpga_device_param $i serial_number)
        ip=$(/opt/cli/get/get_fpga_device_param $i IP)
        mac=$(/opt/cli/get/get_fpga_device_param $i MAC)
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
fi

#GPU devices
if [[ -f "$DEVICE_LIST_GPU" ]]; then
  #print if the first fpga/acap is valid
  device_1=$(head -n 1 "$DEVICE_LIST_GPU")
  bus_1=$(echo "$device_1" | awk '{print $2}')
  if [[ -n "$(lspci | grep $bus_1)" ]]; then
    print_gpu_devices_header
    #get number of gpu devices present
    MAX_GPU_DEVICES=$(grep -E "gpu" $DEVICE_LIST_GPU | wc -l)
    #loop over gpu devices
    for ((i=1; i<=$MAX_GPU_DEVICES; i++)); do
      id=$(/opt/cli/get/get_gpu_device_param $i id) #========================================> I need to update the function
      #print table
      if [ -n "$id" ]; then
        bus=$(/opt/cli/get/get_gpu_device_param $i bus)
        device_type=$(/opt/cli/get/get_gpu_device_param $i device_type)
        gpu_id=$(/opt/cli/get/get_gpu_device_param $i gpu_id)
        serial_number=$(/opt/cli/get/get_gpu_device_param $i serial_number)
        unique_id=$(/opt/cli/get/get_gpu_device_param $i unique_id)
        #print row
        echo "$id            : $bus : $device_type ($gpu_id)         : $serial_number  : $unique_id" 
      fi
    done
    echo ""
  fi
fi