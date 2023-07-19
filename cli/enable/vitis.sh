#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli" #"$(dirname "$(dirname "$0")")"
XILINX_TOOLS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_TOOLS_PATH)
VITIS_PATH="$XILINX_TOOLS_PATH/Vitis"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
read -a flags <<< "$@"

#check on valid Vitis version
if [ -n "$XILINX_VITIS" ]; then
    echo ""
    echo "Vitis is already active on ${bold}$hostname!${normal}"
    echo ""
    #exit
else
    #check on flags
    version_found=""
    version_name=""
    if [ "$flags" = "" ]; then
        #header
        echo ""
        echo "${bold}sgutil enable vitis${normal}"
        #version_dialog
        echo ""
        echo "${bold}Please, choose your Vitis version:${normal}"
        echo ""
        result=$($CLI_PATH/common/version_dialog $VITIS_PATH)
        version_found=$(echo "$result" | sed -n '1p')
        version_name=$(echo "$result" | sed -n '2p')
        echo ""
    else
        #version_dialog_check
        result="$("$CLI_PATH/common/version_dialog_check" "${flags[@]}")"
        version_found=$(echo "$result" | sed -n '1p')
        version_name=$(echo "$result" | sed -n '2p')
        #forbidden combinations
        if [ "$version_found" = "1" ] && ([ "$version_name" = "" ] || [ ! -d "$VITIS_PATH/$version_name" ]); then 
            $CLI_PATH/sgutil enable xrt -h
            exit
        fi
    fi

    #source vitis
    source $XILINX_TOOLS_PATH//Vitis/$version_name/.settings64-Vitis.sh
    source $XILINX_TOOLS_PATH//Vitis_HLS/$version_name/.settings64-Vitis_HLS.sh

    #echo ""

    #print message
    #echo ""
    if [[ -d $VITIS_PATH/$version_name ]]; then
        #Vitis is installed
        echo "The server is ready to work with ${bold}Vitis $version_name${normal} release branch:"
        echo ""
        echo "    Vitis, Vitis_HLS             : ${bold}$VITIS_PATH/$version_name${normal}"
        echo ""
    else
        echo "The server needs special care to operate with Vitis normally (Xilinx tools are not properly installed)."
        echo ""
        echo "${bold}An email has been sent to the person in charge;${normal} we will let you know when Vitis is ready to use again."
        echo "Subject: $hostname requires special attention ($username): Xilinx tools are not properly installed" | sendmail $email
    fi
fi