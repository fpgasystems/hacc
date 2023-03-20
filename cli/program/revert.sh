#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
SERVERADDR="localhost"
EMAIL="jmoyapaya@ethz.ch"

#get username
username=$USER

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

#check for number of pci functions
if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
    #the server is already in Vitis workflow
    echo ""
    exit
fi

echo ""
echo "${bold}sgutil program revert${normal}"

#check for virtualized
virtualized=$(/opt/cli/common/is_virtualized)
if [ "$virtualized" = "true" ]; then
    echo ""
    echo "${bold}The server needs to revert to operate with XRT normally. For this purpose:${normal}"
	echo ""
	echo "    Use the ${bold}revert to xrt${normal} button on the booking system, or"
	echo "    Contact ${bold}$EMAIL${normal} for support."
    echo ""
    #send email
    echo "Subject: $hostname requires to revert_to_xrt ($username)" | sendmail $EMAIL
    exit
fi

#derive actions to perform
name_found="0"
serial_found="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then # flags[i] is -n or --name
        name_found="1"
    fi
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
        serial_found="1"
    fi
done

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(/opt/cli/get/device | cut -d "=" -f2)
fi

#sgutil get serial if there is only one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
fi

#get release branch
branch=$(/opt/xilinx/xrt/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

echo ""
echo "${bold}Programming XRT shell:${normal}"
/tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source /opt/cli/program/flash_xrt_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name

#hotplug
#sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"
sudo /opt/cli/program/pci_hot_plug ${hostname}

#inserting XRT driver
echo "${bold}Inserting XRT drivers:${normal}"
echo ""

if [[ $(lsmod | grep xocl | wc -l) -gt 0 ]]; then #>= 1
    echo "sudo modprobe xocl"
    #sudo bash -c "modprobe xocl"
    sudo modprobe xocl
    sleep 1
fi
if [[ $(lsmod | grep xclmgmt | wc -l) -gt 0 ]]; then #>= 1
    echo "sudo modprobe xclmgmt"
    #sudo bash -c "modprobe xclmgmt"
    sudo modprobe xclmgmt
    sleep 1
fi
echo ""