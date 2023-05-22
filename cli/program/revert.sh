#!/bin/bash

CLI_WORKDIR="/opt/cli"
DATABASE="/opt/hacc/devices"

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

#check on BDF
#if [ "$#" -ne 1 ] ; then
#    echo ""
#    echo "$0: exactly 1 argument expected. Example: /opt/cli/program/revert 81:00.1"
#else
#    bdf=$1 
#    bdf="${bdf%??}" #i.e., we transform 81:00.1 into 81:00
#fi

# inputs
read -a flags <<< "$@"

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
if [ "$flags" = "" ]; then
    #get device index
    if [[ "$multiple_devices" == "0" ]]; then
        #servers with only one FPGA (i.e., alveo-u55c-01)
        device_index="0"
    else
        $CLI_WORKDIR/sgutil program revert -h
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
    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
        $CLI_WORKDIR/sgutil program revert -h
        exit
    fi
fi



#if [ "$flags" = "" ]; then
#    #get device index
#    if [[ "$multiple_devices" == "0" ]]; then
#        #servers with only one FPGA (i.e., alveo-u55c-01)
#        device_index="0"
#    elif [[ "$multiple_devices" == "1" ]]; then #$(lspci | grep Xilinx | wc -l) = 8
#        #servers with four FPGAs (i.e., hacc-box-01)
#        #device_0
#        id_0=$($CLI_WORKDIR/get/get_device_param 0 id)
#        device_type_0=$($CLI_WORKDIR/get/get_device_param 0 device_type)
#        device_name_0=$($CLI_WORKDIR/get/get_device_param 0 device_name)
#        serial_number_0=$($CLI_WORKDIR/get/get_device_param 0 serial_number)
#        #device_1
#        id_1=$($CLI_WORKDIR/get/get_device_param 1 id)
#        device_type_1=$($CLI_WORKDIR/get/get_device_param 1 device_type)
#        device_name_1=$($CLI_WORKDIR/get/get_device_param 1 device_name)
#        serial_number_1=$($CLI_WORKDIR/get/get_device_param 1 serial_number)
#        #device_2
#        id_2=$($CLI_WORKDIR/get/get_device_param 2 id)
#        device_type_2=$($CLI_WORKDIR/get/get_device_param 2 device_type)
#        device_name_2=$($CLI_WORKDIR/get/get_device_param 2 device_name)
#        serial_number_2=$($CLI_WORKDIR/get/get_device_param 2 serial_number)
#        #device_3
#        id_3=$($CLI_WORKDIR/get/get_device_param 3 id)
#        device_type_3=$($CLI_WORKDIR/get/get_device_param 3 device_type)
#        device_name_3=$($CLI_WORKDIR/get/get_device_param 3 device_name)
#        serial_number_3=$($CLI_WORKDIR/get/get_device_param 3 serial_number)
#        #concatenate strings
#        devices=( "$id_0 [$device_type_0 - $device_name_0 - $serial_number_0]" "$id_1 [$device_type_1 - $device_name_1 - $serial_number_1]" "$id_2 [$device_type_2 - $device_name_2 - $serial_number_2]" "$id_3 [$device_type_3 - $device_name_3 - $serial_number_3]")
#        #multiple choice
#        echo ""
#        echo "${bold}Please, choose your device:${normal}"
#        echo ""
#        PS3=""
#        select device_index in "${devices[@]}"; do
#            if [[ -z $device_index ]]; then
#                echo "" >&/dev/null
#            else
#                device_found="1"
#                device_index=${device_index:0:1}
#                break
#            fi
#        done
#    fi
#else
#    #find flags and values
#    for (( i=0; i<${#flags[@]}; i++ ))
#    do
#        if [[ " ${flags[$i]} " =~ " -d " ]] || [[ " ${flags[$i]} " =~ " --device " ]]; then # flags[i] is -d or --device
#            device_found="1"
#            device_idx=$(($i+1))
#            device_index=${flags[$device_idx]}
#        fi    
#    done
#    #forbidden combinations
#    if [[ $device_found = "0" ]] || [[ $device_index = "" ]] || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 0 ))); then
#        $CLI_WORKDIR/sgutil program revert -h
#        exit
#    fi
#fi

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$(/opt/cli/get/get_device_param $device_index upstream_port)
bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00

#check for number of pci functions
if [[ $(lspci | grep Xilinx | grep $bdf | wc -l) = 2 ]]; then
    #the server is already in Vitis workflow
    #echo ""
    #echo "The device ${bold}$upstream_port.1${normal} is ready for Vitis workflow!"
    echo ""
    lspci | grep Xilinx | grep $bdf
    echo ""
    exit
fi

echo ""
echo "${bold}sgutil program revert${normal}"

#sgutil get device if there is only one FPGA and not name_found
#if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
#    #device_name=$(/opt/cli/get/device | cut -d "=" -f2)
#    device_name=$(/opt/cli/get/device -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')
#fi

#sgutil get serial if there is only one FPGA and not serial_found
#if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
#    #serial_number=$(/opt/cli/get/serial | cut -d "=" -f2)
#    serial_number=$(/opt/cli/get/serial -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')
#fi

#get device and serial name
serial_number=$(/opt/cli/get/serial -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')
device_name=$(/opt/cli/get/device -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')

#get release branch
branch=$(/opt/xilinx/xrt/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

echo ""
echo "${bold}Programming XRT shell:${normal}"
/tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source /opt/cli/program/flash_xrt_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name

#hotplug
#sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"
#upstream_port=$(/opt/cli/get/get_device_param $device_index upstream_port)
root_port=$(/opt/cli/get/get_device_param $device_index root_port)
LinkCtl=$(/opt/cli/get/get_device_param $device_index LinkCtl)
sudo /opt/cli/program/pci_hot_plug $upstream_port $root_port $LinkCtl #${hostname}

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
lspci | grep Xilinx | grep $bdf
echo ""