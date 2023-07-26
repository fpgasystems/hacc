#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$0")"
XRT_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XRT_PATH)
DEVICE_LIST_FPGA="$CLI_PATH/devices_acap_fpga"
DEVICE_LIST_GPU="$CLI_PATH/devices_gpu"
DEVICE_TYPE_NAME_STR_LENGTH=20
NETWORKING_STR_LENGTH=35

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
  echo "${bold}Device Index : Upstream port (BFD) : Device Type (Name)   : Serial Number : Networking                          : Workflow${normal}"
  echo "${bold}--------------------------------------------------------------------------------------------------------------------------${normal}"
}

print_gpu_devices_header (){
  echo "${bold}Device Index : PCI BUS : Device Type (GPU ID) : Serial Number : Unique ID${normal}"
  echo "${bold}--------------------------------------------------------------------------------------------------------------------------${normal}"
}

#CPU server (both lists are empty)
if ! ([[ -s "$DEVICE_LIST_FPGA" ]] && [[ -s "$DEVICE_LIST_GPU" ]]); then
  echo ""
  echo "System Configuration"
  echo "OS Name              : $(uname -s)"
  echo "Release              : $(uname -r)"
  echo "Version              : $(uname -v)"
  echo "Machine              : $(uname -m)"
  echo "CPU Cores            : $(nproc)"
  echo "Memory               : $(free -m | awk 'NR==2{print $2}') MB"
  echo "Distribution         : $(lsb_release -d | awk -F ':\t' '{print $2}' | sed 's/^[ \t]*//')"
  echo ""
fi

#reconfigurable devices
if [[ -s "$DEVICE_LIST_FPGA" ]]; then
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
      id=$($CLI_PATH/get/get_fpga_device_param $i id)
      #print table
      if [ -n "$id" ]; then  
        upstream_port=$($CLI_PATH/get/get_fpga_device_param $i upstream_port)
        device_type=$($CLI_PATH/get/get_fpga_device_param $i device_type)
        device_name=$($CLI_PATH/get/get_fpga_device_param $i device_name)
        serial_number=$($CLI_PATH/get/get_fpga_device_param $i serial_number)
        ip=$($CLI_PATH/get/get_fpga_device_param $i IP)
        mac=$($CLI_PATH/get/get_fpga_device_param $i MAC)
        workflow=$($CLI_PATH/get/workflow -d $i)
        workflow=$(echo "$workflow" $i | cut -d' ' -f2 | sed '/^\s*$/d')
        bdf="${upstream_port::-1}1"
        #adjust device type and name string length
        aux="$device_type ($device_name)"
        diff=$(( $DEVICE_TYPE_NAME_STR_LENGTH - ${#aux} ))
        device_type_name="$aux$(printf '%*s' $diff)"
        #split ip
        add_0=$(split_addresses $ip $mac 0)
        add_1=$(split_addresses $ip $mac 1)
        #adjust networking string length
        diff=$(( $NETWORKING_STR_LENGTH - ${#add_0} ))
        add_0="$add_0$(printf '%*s' $diff)"
        add_1="$add_1$(printf '%*s' $diff)"
        #print row
        echo "$id            : $upstream_port ($bdf)   : $device_type_name : $serial_number : $add_0 : $workflow"
        echo "                                                                            $add_1"
      fi
    done
    echo ""
  fi
fi

#GPU devices
if [[ -s "$DEVICE_LIST_GPU" ]]; then
  #print if the first fpga/acap is valid
  device_1=$(head -n 1 "$DEVICE_LIST_GPU")
  bus_1=$(echo "$device_1" | awk '{print $2}')
  if [[ -n "$(lspci | grep $bus_1)" ]]; then
    print_gpu_devices_header
    #get number of gpu devices present
    MAX_GPU_DEVICES=$(grep -E "gpu" $DEVICE_LIST_GPU | wc -l)
    #loop over gpu devices
    for ((i=1; i<=$MAX_GPU_DEVICES; i++)); do
      id=$($CLI_PATH/get/get_gpu_device_param $i id) #========================================> I need to update the function
      #print table
      if [ -n "$id" ]; then
        bus=$($CLI_PATH/get/get_gpu_device_param $i bus)
        device_type=$($CLI_PATH/get/get_gpu_device_param $i device_type)
        gpu_id=$($CLI_PATH/get/get_gpu_device_param $i gpu_id)
        serial_number=$($CLI_PATH/get/get_gpu_device_param $i serial_number)
        unique_id=$($CLI_PATH/get/get_gpu_device_param $i unique_id)
        #print row
        echo "$id            : $bus : $device_type ($gpu_id)         : $serial_number  : $unique_id" 
      fi
    done
    echo ""
  fi
fi