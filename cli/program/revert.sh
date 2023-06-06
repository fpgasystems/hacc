#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
SERVERADDR="localhost"

#get username
username=$USER

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#get email
email=$(/opt/cli/common/get_email)

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

# inputs
read -a flags <<< "$@"

#check for virtualized
virtualized=$(/opt/cli/common/is_virtualized)
if [ "$virtualized" = "true" ]; then
    echo ""
    echo "${bold}The server needs to revert to operate with XRT normally. For this purpose:${normal}"
	echo ""
	echo "    Use the ${bold}revert to xrt${normal} button on the booking system, or"
	echo "    Contact ${bold}$email${normal} for support."
    echo ""
    #send email
    echo "Subject: $hostname requires to revert_to_xrt ($username)" | sendmail $email
    exit
fi

#check on multiple Xilinx devices
num_devices=$(/opt/cli/common/get_num_devices)
if [[ -z "$num_devices" ]] || [[ "$num_devices" -eq 0 ]]; then
    echo ""
    echo "Please, update $DEVICES_LIST according to your infrastructure."
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
        $CLI_PATH/sgutil program revert -h
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
        $CLI_PATH/sgutil program revert -h
        exit
    fi
fi

#device_index should be between {0 .. MAX_DEVICES - 1}
#MAX_DEVICES=$(($MAX_DEVICES-1))
if [[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]]; then
    $CLI_PATH/sgutil program revert -h
    exit
fi

#get BDF (i.e., Bus:Device.Function) 
upstream_port=$(/opt/cli/get/get_fpga_device_param $device_index upstream_port)
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

#get device and serial name
serial_number=$(/opt/cli/get/serial -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')
device_name=$(/opt/cli/get/device -d $device_index | awk -F': ' '{print $2}' | grep -v '^$')

#get release branch
branch=$($XRT_PATH/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

echo ""
echo "${bold}Programming XRT shell:${normal}"
/tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source /opt/cli/program/flash_xrt_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name

#hotplug
#sudo bash -c "source /opt/cli/program/pci_hot_plug ${hostname}"
#upstream_port=$(/opt/cli/get/get_fpga_device_param $device_index upstream_port)
root_port=$(/opt/cli/get/get_fpga_device_param $device_index root_port)
LinkCtl=$(/opt/cli/get/get_fpga_device_param $device_index LinkCtl)
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