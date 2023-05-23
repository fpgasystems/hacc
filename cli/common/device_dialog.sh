#!/bin/bash

CLI_WORKDIR=$1 
MAX_DEVICES=$2 
multiple_devices=$3

# Declare global variables
declare -g device_found=""
declare -g device_index=""

#get device index
if [[ "$multiple_devices" == "0" ]]; then
    #servers with only one FPGA (i.e., alveo-u55c-01)
    device_index="0"
elif [[ "$multiple_devices" == "1" ]]; then #$(lspci | grep Xilinx | wc -l) = 8
    #servers with four FPGAs (i.e., hacc-box-01)
    ##device_0
    #id_0=$($CLI_WORKDIR/get/get_device_param 0 id)
    #device_type_0=$($CLI_WORKDIR/get/get_device_param 0 device_type)
    #device_name_0=$($CLI_WORKDIR/get/get_device_param 0 device_name)
    #serial_number_0=$($CLI_WORKDIR/get/get_device_param 0 serial_number)
    ##device_1
    #id_1=$($CLI_WORKDIR/get/get_device_param 1 id)
    #device_type_1=$($CLI_WORKDIR/get/get_device_param 1 device_type)
    #device_name_1=$($CLI_WORKDIR/get/get_device_param 1 device_name)
    #serial_number_1=$($CLI_WORKDIR/get/get_device_param 1 serial_number)
    ##device_2
    #id_2=$($CLI_WORKDIR/get/get_device_param 2 id)
    #device_type_2=$($CLI_WORKDIR/get/get_device_param 2 device_type)
    #device_name_2=$($CLI_WORKDIR/get/get_device_param 2 device_name)
    #serial_number_2=$($CLI_WORKDIR/get/get_device_param 2 serial_number)
    ##device_3
    #id_3=$($CLI_WORKDIR/get/get_device_param 3 id)
    #device_type_3=$($CLI_WORKDIR/get/get_device_param 3 device_type)
    #device_name_3=$($CLI_WORKDIR/get/get_device_param 3 device_name)
    #serial_number_3=$($CLI_WORKDIR/get/get_device_param 3 serial_number)
    ##concatenate strings
    #devices=( "$id_0 [$device_type_0 - $device_name_0 - $serial_number_0]" "$id_1 [$device_type_1 - $device_name_1 - $serial_number_1]" "$id_2 [$device_type_2 - $device_name_2 - $serial_number_2]" "$id_3 [$device_type_3 - $device_name_3 - $serial_number_3]")
    
    
    # Declare an empty array to store the device strings
    devices=()

    # Iterate over the indices 0 to MAX_DEVICES-1 using a for loop
    for ((i=0; i<MAX_DEVICES; i++)); do
        # Retrieve the parameters for each device using the current index
        id=$($CLI_WORKDIR/get/get_device_param $i id)
        device_type=$($CLI_WORKDIR/get/get_device_param $i device_type)
        device_name=$($CLI_WORKDIR/get/get_device_param $i device_name)
        serial_number=$($CLI_WORKDIR/get/get_device_param $i serial_number)
        
        # Concatenate the parameter values into a single string and add it to the array
        devices+=("$id [$device_type - $device_name - $serial_number]")
    done
    
    
    #multiple choice
    #echo ""
    #echo "${bold}Please, choose your device:${normal}"
    #echo ""
    PS3=""
    select device_index in "${devices[@]}"; do
        if [[ -z $device_index ]]; then
            echo "" >&/dev/null
        else
            device_found="1"
            device_index=${device_index:0:1}
            break
        fi
    done
fi

# Return the values of device_found and device_index
echo "$device_found"
echo "$device_index"