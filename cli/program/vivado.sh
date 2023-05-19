#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
EMAIL="jmoyapaya@ethz.ch"
SERVERADDR="localhost"

#get username
username=$USER

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# inputs
read -a flags <<< "$@"

echo ""
echo "${bold}sgutil program vivado${normal}"

#check for vivado_developers
member=$(/opt/cli/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

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
        name_idx=$(($i+1))
        device_name=${flags[$name_idx]}
    fi
    if [[ " ${flags[$i]} " =~ " -s " ]] || [[ " ${flags[$i]} " =~ " --serial " ]]; then 
        serial_found="1"
        serial_idx=$(($i+1))
        serial_number=${flags[$serial_idx]}
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

# when used, bit_file, ltx_file or driver_file cannot be empty and has to exist
if [ "$program_bitstream" = "1" ] && ([ "$bit_file" = "" ] || [ ! -f "$bit_file" ]); then
    /opt/cli/sgutil program vivado -h
    exit
fi

if [ "$ltx_found" = "1" ] && ([ "$ltx_file" = "" ] || [ ! -f "$ltx_file" ]); then
    /opt/cli/sgutil program vivado -h
    exit
fi

if [ "$program_driver" = "1" ] && ([ "$driver_file" = "" ] || [ ! -f "$driver_file" ]); then
    /opt/cli/sgutil program vivado -h
    exit
fi

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    #device_name=$(/opt/cli/get/device | cut -d "=" -f2)
    device_name=$(/opt/cli/get/device | awk -F': ' '{print $2}' | grep -v '^$')
fi

#sgutil get serial if there is only one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    #serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
    serial_number=$(/opt/cli/get/serial | awk -F': ' '{print $2}' | grep -v '^$')
fi

#get release branch
branch=$(/opt/xilinx/xrt/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

if [[ $program_bitstream = "1" ]]; then

    #revert to xrt first if FPGA is already in baremetal (it is proven to be needed on non-virtualized environments)
    virtualized=$(/opt/cli/common/is_virtualized)
    if [ "$virtualized" = "false" ] && [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then 
        sudo /opt/cli/program/revert
    fi

    echo ""
	echo "${bold}Programming bitstream:${normal}"
    /tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source /opt/cli/program/flash_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name $bit_file $ltx_file

    #check for virtualized and apply PCI hot plug
    if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
        if [ "$virtualized" = "true" ]; then
            echo ""
            echo "${bold}The server needs to warm boot to operate in Vivado workflow. For this purpose:${normal}"
		    echo ""
		    echo "    Use the ${bold}go to baremetal${normal} button on the booking system, or"
		    echo "    Contact ${bold}$EMAIL${normal} for support."
            echo ""
            #send email
            echo "Subject: $username requires to go to baremetal/warm boot ($hostname)" | sendmail $EMAIL
            exit
        elif [ "$virtualized" = "false" ]; then
            #sudo /opt/cli/program/pci_hot_plug ${hostname}
            /opt/cli/program/rescan
        fi
    fi

    #check for virtualized and apply PCI hot plug
    #virtualized=$(/opt/cli/common/is_virtualized)
    #if [ "$virtualized" = "true" ]; then
    #    echo ""
    #    echo "${bold}The server needs to warm boot to operate in Vivado workflow. For this purpose:${normal}"
	#	echo ""
	#	echo "    Use the ${bold}go to baremetal${normal} button on the booking system, or"
	#	echo "    Contact ${bold}$EMAIL${normal} for support."
    #    echo ""
    #    #send email
    #    echo "Subject: $username requires to warm boot/go to baremetal ($hostname)" | sendmail $EMAIL
    #    exit
    #elif [ "$virtualized" = "false" ]; then
    #    #run PCI hot plug
    #    if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
    #        sudo /opt/cli/program/pci_hot_plug ${hostname}
    #    fi
    #fi
fi

if [[ $program_driver = "1" ]]; then

    #we need to copy the driver to /local to avoid permission problems
	echo ""
    echo "${bold}Copying driver to /local/home/$username:${normal}"
	echo ""
    echo "cp -f $driver_file /local/home/$username"
    
    cp -f $driver_file /local/home/$username

    #get driver name
    driver_name=$(echo $driver_file | awk -F"/" '{print $NF}')

    #insert coyote driver
	echo ""
    echo "${bold}Inserting driver:${normal}"
	echo ""

    # we always remove and insert the driver
    echo "sudo rmmod $driver_name" #$driver_file
    #sudo bash -c "rmmod $driver_file"
    sudo rmmod $driver_name #$driver_file
    sleep 1
    echo "sudo insmod /local/home/$username/$driver_name" #$driver_file
    #sudo bash -c "insmod $driver_file"
    sudo insmod /local/home/$username/$driver_name #$driver_file
    sleep 1

    echo ""

    #sudo bash -c "/opt/cli/program/fpga_chmod 0"
    #sudo /opt/cli/program/fpga_chmod 0 ===========> this belongs to coyote

fi