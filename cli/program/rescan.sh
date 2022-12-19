#!/bin/bash

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
    fi
done

#sgutil get serial if there is only one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
fi

#hotplug ----------------------------------------------------------> we will need to adapt it to use the serial number
#sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"
sudo /opt/cli/program/pci_hot_plug ${hostname}