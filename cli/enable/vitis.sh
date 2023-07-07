#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli" #"$(dirname "$(dirname "$0")")"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
XILINX_TOOLS_PATH="/tools/Xilinx"
VITIS_PATH="$XILINX_TOOLS_PATH/Vitis"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on valid XRT version
if [ -n "$XILINX_VITIS" ]; then
    echo ""
    echo "Vitis is already active on ${bold}$hostname!${normal}"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

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

#copy the desired XRT version to user’s local and preserve /opt/xilinx/xrt structure (Xilinx workaroud)
#mkdir -p /local/home/$USER/xrt_${version_name}$XRT_PATH
#cp -r $XRT_PATH"_"${version_name}/* /local/home/$USER/xrt_${version_name}$XRT_PATH 

#source vitis
source $XILINX_TOOLS_PATH//Vitis/2022.1/.settings64-Vitis.sh
source $XILINX_TOOLS_PATH//Vitis_HLS/2022.1/.settings64-Vitis_HLS.sh
export XILINX_VITIS=$VITIS_PATH/$version_name

#echo ""

#print message
echo ""
if [[ -d $VITIS_PATH/$version_name ]]; then
    #Vitis is installed
    echo "The server is ready to work with ${bold}Vitis $version_name${normal} release branch:"
    echo ""
    #echo "    Xilinx Board Utility (xbutil)          : ${bold}$XILINX_XRT/bin${normal}"
    echo "    Xilinx Tools (Vitis, Vitis_HLS)        : ${bold}$XILINX_TOOLS_PATH${normal}"
#elif [[ -d $VITIS_PATH/$version_name ]]; then
#    #Vitis is not installed
#    echo "The server is ready to work with Xilinx ${bold}$version_name${normal} release branch:"
#    echo ""
#    echo "    Xilinx Board Utility (xbutil)       : ${bold}$XILINX_XRT/bin${normal}"
#    echo "    Xilinx Tools (Vivado, Vitis_HLS)    : ${bold}$XILINX_TOOLS_PATH${normal}"
else
    echo "The server needs special care to operate with XRT normally (Xilinx tools are not properly installed)."
    echo ""
    echo "${bold}An email has been sent to the person in charge;${normal} we will let you know when XRT is ready to use again."
    echo "Subject: $hostname requires special attention ($username): Xilinx tools are not properly installed" | sendmail $email
fi

echo ""