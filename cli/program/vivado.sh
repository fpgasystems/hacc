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
name_found="0"
serial_found="0"
program_bitstream="0"
ltx_found="0"
ltx_file=""
program_driver="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then # flags[i] is -n or --name
        name_found="1"
    fi
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
        serial_found="1"
    fi
    if [[ " ${flags[$i]} " =~ " -b " ]] || [[ " ${flags[$i]} " =~ " --bitstream " ]]; then 
        program_bitstream="1"
        bit_idx=$(($i+1))
        bit_file=${flags[$bit_idx]}
    fi
    if [[ " ${flags[$i]} " =~ " -l " ]] || [[ " ${flags[$i]} " =~ " --ltx " ]]; then 
        ltx_found="1"
        ltx_idx=$(($i+1))
        ltx_file=${flags[$ltx_idx]}
    fi
    if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --driver " ]]; then
        program_driver="1"
        driver_idx=$(($i+1))
        driver_file=${flags[$driver_idx]}
    fi
done

# mandatory flags (-b or -d should be used)
use_help="0"
if [[ $program_bitstream = "0" ]] && [[ $program_driver = "0" ]]; then # with && both conditions must be true
    use_help="1"
fi

# forbiden combinations (name_found, serial_found and ltx_found only make sense with program_bitstream = 1)
if [[ $program_bitstream = "0" ]] && [[ $name_found = "1" ]]; then
    use_help="1"
fi
if [[ $program_bitstream = "0" ]] && [[ $serial_found = "1" ]]; then
    use_help="1"
fi
if [[ $program_bitstream = "0" ]] && [[ $ltx_found = "1" ]]; then
    use_help="1"
fi

#print help
if [[ $use_help = "1" ]]; then
    /opt/cli/sgutil program vivado -h
    exit
fi

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

if [[ $program_bitstream = "1" ]]; then
    
    echo ""
	echo "${bold}Programming bitstream:${normal}"
    /tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source /opt/cli/program/flash_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name $bit_file $ltx_file

    #hotplug
    if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
        #sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"
        sudo /opt/cli/program/pci_hot_plug ${hostname}
    fi
fi

if [[ $program_driver = "1" ]]; then

    #insert coyote driver
	echo ""
    echo "${bold}Inserting driver:${normal}"
	echo ""

    # we always remove and insert the driver
    echo "sudo rmmod $driver_file"
    #sudo bash -c "rmmod $driver_file"
    sudo rmmod $driver_file
    sleep 1
    echo "sudo insmod $driver_file"
    #sudo bash -c "insmod $driver_file"
    sudo insmod $driver_file
    sleep 1

    #sudo bash -c "/opt/cli/program/fpga_chmod 0"
    sudo /opt/cli/program/fpga_chmod 0

fi