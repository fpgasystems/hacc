#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program reset${normal}"

#check for virtualized
#virtualized=$(/opt/cli/common/is_virtualized)
#if [ "$virtualized" = "true" ]; then
#    echo ""
#    echo "Sorry, this command is only available for ${bold}non-virtualized servers.${normal}"
#    echo ""
#    exit
#fi

#check for vivado_developers
#member=$(/opt/cli/common/is_member $username vivado_developers)
#if [ "$member" = "false" ]; then
#    echo ""
#    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
#    echo ""
#    exit
#fi

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
    #serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
    serial_number="--device"
fi

#revert
/opt/cli/program/revert 

#reset device (we delete any xclbin)
/opt/xilinx/xrt/bin/xbutil reset $serial_number --force

echo ""