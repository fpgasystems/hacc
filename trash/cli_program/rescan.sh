#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

CLI_WORKDIR="/opt/cli"
DATABASE="/opt/hacc/devices"
MAX_DEVICES=4

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#check for virtualized
virtualized=$(/opt/cli/common/is_virtualized)
if [ "$virtualized" = "true" ]; then
    echo ""
    echo "Sorry, this command is only available for ${bold}non-virtualized servers.${normal}"
    echo ""
    exit
fi

#check for vivado_developers
member=$(/opt/cli/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#check on multiple Xilinx devices
num_devices=$(/opt/cli/common/get_num_devices)
if [[ -z "$num_devices" ]] || [[ "$num_devices" -eq 0 ]]; then
    echo ""
    echo "Please, update $DATABASE according to your infrastructure."
    echo ""
    exit
elif [[ "$num_devices" -eq 1 ]]; then
    multiple_devices="0"
else
    multiple_devices="1"
fi

#check on flags
device_found="0"
if [ "$flags" = "" ]; then
    #get device index
    if [[ "$multiple_devices" == "0" ]]; then
        #servers with only one FPGA (i.e., alveo-u55c-01)
        device_index="1"
    else
        $CLI_WORKDIR/sgutil program rescan -h
        exit
    fi
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
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))); then
        $CLI_WORKDIR/sgutil program rescan -h
        exit
    fi
fi

#device_index should be between {0 .. MAX_DEVICES - 1}
#MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
    $CLI_WORKDIR/sgutil program revert -h
    exit
fi

echo ""
echo "${bold}sgutil program rescan${normal}"

#pci_hot_plug
upstream_port=$(/opt/cli/get/get_device_param $device_index upstream_port)
root_port=$(/opt/cli/get/get_device_param $device_index root_port)
LinkCtl=$(/opt/cli/get/get_device_param $device_index LinkCtl)
sudo /opt/cli/program/pci_hot_plug $upstream_port $root_port $LinkCtl #${hostname}

bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00
lspci | grep Xilinx | grep $bdf
echo ""