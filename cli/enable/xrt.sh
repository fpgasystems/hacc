#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli" #"$(dirname "$(dirname "$0")")"
LOCAL_PATH=$($CLI_PATH/common/get_constant $CLI_PATH LOCAL_PATH)
XRT_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XRT_PATH)
XILINX_TOOLS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_TOOLS_PATH)
VIVADO_PATH="$XILINX_TOOLS_PATH/Vivado"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#inputs
read -a flags <<< "$@"

#check on valid XRT version
if [ -n "$XILINX_XRT" ]; then #if [ -z "$(echo $XILINX_XRT)" ]; then
    echo ""
    echo "Xilinx Runtime (XRT) is already active on ${bold}$hostname!${normal}"
    echo ""
    #exit
else
    #check on flags
    version_found=""
    version_name=""
    if [ "$flags" = "" ]; then
        #header
        echo ""
        echo "${bold}sgutil enable xrt${normal}"
        #version_dialog
        echo ""
        echo "${bold}Please, choose your XRT version:${normal}"
        echo ""
        result=$($CLI_PATH/common/version_dialog $VIVADO_PATH)
        version_found=$(echo "$result" | sed -n '1p')
        version_name=$(echo "$result" | sed -n '2p')
        echo ""
    else
        #version_dialog_check
        result="$("$CLI_PATH/common/version_dialog_check" "${flags[@]}")"
        version_found=$(echo "$result" | sed -n '1p')
        version_name=$(echo "$result" | sed -n '2p')
        #forbidden combinations
        if [ "$version_found" = "1" ] && ([ "$version_name" = "" ] || [ ! -d "$VIVADO_PATH/$version_name" ]); then 
            $CLI_PATH/sgutil enable xrt -h
            exit
        fi
    fi

    #copy the desired XRT version to user’s local and preserve /opt/xilinx/xrt structure (Xilinx workaroud)
    mkdir -p $LOCAL_PATH/xrt_${version_name}$XRT_PATH
    cp -r $XRT_PATH"_"${version_name}/* $LOCAL_PATH/xrt_${version_name}$XRT_PATH 

    #source xrt
    source $LOCAL_PATH/xrt_${version_name}$XRT_PATH/setup.sh

    echo ""

    #print message
    #echo ""
    if [[ -d $VIVADO_PATH/$version_name ]]; then
        #Vitis is not installed
        echo "The server is ready to work with ${bold}XRT $version_name${normal} release branch:"
        echo ""
        echo "    Xilinx Board Utility (xbutil): ${bold}$XILINX_XRT/bin${normal}"
        echo ""
    else
        echo "The server needs special care to operate with XRT normally (Xilinx tools are not properly installed)."
        echo ""
        echo "${bold}An email has been sent to the person in charge;${normal} we will let you know when XRT is ready to use again."
        echo "Subject: $hostname requires special attention ($username): Xilinx tools are not properly installed" | sendmail $email
    fi
fi