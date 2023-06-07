#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
HACC_PATH="/opt/hacc"
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
    echo "$bitstream_found"
    echo "$driver_found"
    #forbidden combinations (3)
    if ([ "$bitstream_found" = "0" ] && [ "$driver_found" = "0" ]); then
        $CLI_PATH/sgutil program vivado -h
        exit
    fi
fi

echo ""
echo "${bold}sgutil program vivado${normal}"

echo "-b: $bitstream_name"
echo "--device: $device_index"
echo "--driver: $driver_name"

exit

#-----------------------



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
    $CLI_PATH/sgutil program vivado -h
    exit
fi

# when used, bit_file, ltx_file or driver_file cannot be empty and has to exist
if [ "$program_bitstream" = "1" ] && ([ "$bit_file" = "" ] || [ ! -f "$bit_file" ]); then
    $CLI_PATH/sgutil program vivado -h
    exit
fi

if [ "$ltx_found" = "1" ] && ([ "$ltx_file" = "" ] || [ ! -f "$ltx_file" ]); then
    $CLI_PATH/sgutil program vivado -h
    exit
fi

if [ "$program_driver" = "1" ] && ([ "$driver_file" = "" ] || [ ! -f "$driver_file" ]); then
    $CLI_PATH/sgutil program vivado -h
    exit
fi

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    #device_name=$($CLI_PATH/get/device | cut -d "=" -f2)
    device_name=$($CLI_PATH/get/device | awk -F': ' '{print $2}' | grep -v '^$')
fi

#sgutil get serial if there is only one FPGA and not serial_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $serial_found = "0" ]]; then
    #serial_number=$($CLI_PATH/get/serial | cut -d "=" -f2)
    serial_number=$($CLI_PATH/get/serial | awk -F': ' '{print $2}' | grep -v '^$')
fi

#get release branch
branch=$(/opt/xilinx/xrt/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

if [[ $program_bitstream = "1" ]]; then

    #revert to xrt first if FPGA is already in baremetal (it is proven to be needed on non-virtualized environments)
    virtualized=$($CLI_PATH/common/is_virtualized)
    if [ "$virtualized" = "false" ] && [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then 
        sudo $CLI_PATH/program/revert
    fi

    echo ""
	echo "${bold}Programming bitstream:${normal}"
    /tools/Xilinx/Vivado/${branch:7:6}/bin/vivado -nolog -nojournal -mode batch -source $CLI_PATH/program/flash_bitstream.tcl -tclargs $SERVERADDR $serial_number $device_name $bit_file $ltx_file

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
            #sudo $CLI_PATH/program/pci_hot_plug ${hostname}
            #$CLI_PATH/program/rescan
            device_index=1
            upstream_port=$($CLI_PATH/get/get_fpga_device_param $device_index upstream_port)
            root_port=$($CLI_PATH/get/get_fpga_device_param $device_index root_port)
            LinkCtl=$($CLI_PATH/get/get_fpga_device_param $device_index LinkCtl)
            sudo $CLI_PATH/program/pci_hot_plug $upstream_port $root_port $LinkCtl #${hostname}

            bdf="${upstream_port%??}" #i.e., we transform 81:00.0 into 81:00
            lspci | grep Xilinx | grep $bdf
            echo ""
        fi
    fi
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

fi