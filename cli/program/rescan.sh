#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
SERVERADDR="localhost"

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#derive actions to perform
serial_found="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
        serial_found="1"
        #echo "serial_found"
        #echo "i (serial_found)= $i"
    fi
done

#sgutil get serial if there is only one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
    #echo "serial_number=$serial_number"
fi

#hotplug ----------------------------------------------------------> we will need to adapt it to use the serial number
sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"