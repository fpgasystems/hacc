#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
VIVADO_PATH="/tools/Xilinx/Vivado"
DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
SERVERADDR="localhost"

#get username
username=$USER

# get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#get email
email=$($CLI_PATH/common/get_email)

#check on DEVICES_LIST
source "$CLI_PATH/common/device_list_check" "$DEVICES_LIST"

#get number of fpga and acap devices present
MAX_DEVICES=$(grep -E "fpga|acap" $DEVICES_LIST | wc -l)

#check on multiple devices
multiple_devices=$($CLI_PATH/common/get_multiple_devices $MAX_DEVICES)

#check on vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
device_found=""
device_index=""
if [ "$flags" = "" ]; then
    $CLI_PATH/sgutil program vivado -h
    exit
else
    #device_dialog_check
    result="$("$CLI_PATH/common/device_dialog_check" "${flags[@]}")"
    device_found=$(echo "$result" | sed -n '1p')
    device_index=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if ([ "$device_found" = "1" ] && [ "$device_index" = "" ]) || ([ "$device_found" = "1" ] && [ "$multiple_devices" = "0" ] && (( $device_index != 1 ))) || ([ "$device_found" = "1" ] && ([[ "$device_index" -gt "$MAX_DEVICES" ]] || [[ "$device_index" -lt 1 ]])); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #device_dialog (forgotten mandatory)
    if [[ $multiple_devices = "0" ]]; then
        device_found="1"
        device_index="1"
    elif [[ $device_found = "0" ]]; then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #bitstream_dialog_check
    result="$("$CLI_PATH/common/bitstream_dialog_check" "${flags[@]}")"
    bitstream_found=$(echo "$result" | sed -n '1p')
    bitstream_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations (1)
    if [ "$bitstream_found" = "1" ] && ([ "$bitstream_name" = "" ] || [ ! -f "$bitstream_name" ] || [ "${bitstream_name##*.}" != "bit" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #driver_dialog_check
    result="$("$CLI_PATH/common/driver_dialog_check" "${flags[@]}")"
    driver_found=$(echo "$result" | sed -n '1p')
    driver_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations (2)
    if [ "$driver_found" = "1" ] && ([ "$driver_name" = "" ] || [ ! -f "$driver_name" ] || [ "${driver_name##*.}" != "ko" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
    #forbidden combinations (3)
    if ([ "$bitstream_found" = "0" ] && [ "$driver_found" = "0" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
fi

echo ""
echo "${bold}sgutil program vivado${normal}"

#get release branch
branch=$($XRT_PATH/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

#program bitstream
if [[ $bitstream_found = "1" ]]; then
    #revert to xrt first if FPGA is already in baremetal (it is proven to be needed on non-virtualized environments)
    virtualized=$($CLI_PATH/common/is_virtualized)
    if [ "$virtualized" = "false" ] && [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then 
        sudo $CLI_PATH/program/revert
    fi

    #get serial number
    serial_number=$(/opt/cli/get/get_fpga_device_param $device_index serial_number)

    #get device name
    device_name=$(/opt/cli/get/get_fpga_device_param $device_index device_name)

    echo ""
	echo "${bold}Programming bitstream:${normal}"
    $VIVADO_PATH/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source $CLI_PATH/program/flash_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name $bitstream_name

    #check for virtualized and apply PCI hot plug
    if [[ $(lspci | grep Xilinx | wc -l) = 2 ]]; then
        if [ "$virtualized" = "true" ]; then
            echo ""
            echo "${bold}The server needs to warm boot to operate in Vivado workflow. For this purpose:${normal}"
		    echo ""
		    echo "    Use the ${bold}go to baremetal${normal} button on the booking system, or"
		    echo "    Contact ${bold}$email${normal} for support."
            echo ""
            #send email
            echo "Subject: $username requires to go to baremetal/warm boot ($hostname)" | sendmail $email
            exit
        elif [ "$virtualized" = "false" ]; then
            #get device params
            upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
            root_port=$($CLI_PATH/get/get_fpga_device_param $device_index root_port)
            LinkCtl=$($CLI_PATH/get/get_fpga_device_param $device_index LinkCtl)
            #hot plug boot
            sudo $CLI_PATH/program/pci_hot_plug $upstream_port $root_port $LinkCtl
            #print
            bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00
            lspci | grep Xilinx | grep $bdf
            echo ""
        fi
    fi
fi

#program driver
if [[ $driver_found = "1" ]]; then
    #we need to copy the driver to /local to avoid permission problems
	echo ""
    echo "${bold}Copying driver to /local/home/$username:${normal}"
	echo ""
    echo "cp -f $driver_name /local/home/$username"
    cp -f $driver_name /local/home/$username

    #insert coyote driver
	echo ""
    echo "${bold}Inserting driver:${normal}"
	echo ""

    #we always remove and insert the driver
    echo "sudo rmmod $driver_name"
    sudo rmmod $driver_name
    sleep 1
    echo "sudo insmod /local/home/$username/$driver_name"
    sudo insmod /local/home/$username/$driver_name
    sleep 1
    echo ""
fi