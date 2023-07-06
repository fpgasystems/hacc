#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli" #"$(dirname "$(dirname "$0")")"
HACC_PATH="/opt/hacc"
XRT_PATH="/opt/xilinx/xrt"
VIVADO_PATH="/tools/Xilinx/Vivado"
#DEVICES_LIST="$HACC_PATH/devices_reconfigurable"
#MY_PROJECTS_PATH=$($CLI_PATH/common/get_path $CLI_PATH MY_PROJECTS_PATH)
#WORKFLOW="vitis"
#TARGET="hw"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on ACAP or FPGA servers (server must have at least one ACAP or one FPGA)
#acap=$($CLI_PATH/common/is_acap $CLI_PATH $hostname)
#fpga=$($CLI_PATH/common/is_fpga $CLI_PATH $hostname)
#if [ "$acap" = "0" ] && [ "$fpga" = "0" ]; then
#    echo ""
#    echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
#    echo ""
#    exit
#fi

#check on valid XRT version
if [ -n "$XILINX_XRT" ]; then #if [ -z "$(echo $XILINX_XRT)" ]; then
    echo ""
    echo "Xilinx Runtime (XRT) is already active on ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#inputs
read -a flags <<< "$@"

#check on flags
version_found=""
version_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil enable xrt${normal}"
    #version_dialog
    echo ""
    echo "${bold}Please, choose your XRT version:${normal}"
    echo ""
    result=$($CLI_PATH/common/version_dialog $VIVADO_PATH)
    version_found=$(echo "$result" | sed -n '1p')
    version_name=$(echo "$result" | sed -n '2p')
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
    #header (2/2)
    echo ""
    echo "${bold}sgutil enable xrt${normal}"
    echo ""
    #version_dialog (forgotten mandatory 1)
    if [[ $version_found = "0" ]]; then
        #echo ""
        echo "${bold}Please, choose your XRT version:${normal}"
        echo ""
        result=$($CLI_PATH/common/version_dialog $VIVADO_PATH)
        version_found=$(echo "$result" | sed -n '1p')
        version_name=$(echo "$result" | sed -n '2p')
    fi
fi

#copy the desired XRT version to user’s local and preserve /opt/xilinx/xrt structure (Xilinx workaroud)
mkdir -p /local/home/$USER/xrt_${version_name}$XRT_PATH
cp -r $XRT_PATH"_"${version_name}/* /local/home/$USER/xrt_${version_name}$XRT_PATH

echo "" 

#source xrt
source /local/home/$USER/xrt_${version_name}$XRT_PATH/setup.sh

echo ""

#get XRT branch
branch=$($XILINX_XRT/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')

#print message
echo ""
if [[ -d $VITIS_PATH/${branch:7:6} ]]; then
    #Vitis is installed
    echo "The server is ready to work with Xilinx ${bold}${branch:7:6}${normal} release branch:"
    echo ""
    echo "    Xilinx Board Utility (xbutil)          : ${bold}$XILINX_XRT/bin${normal}"
    echo "    Xilinx Tools (Vivado, Vitis, Vitis_HLS): ${bold}/tools/Xilinx${normal}"
elif [[ -d $VIVADO_PATH/${branch:7:6} ]]; then
    #Vitis is not installed
    echo "The server is ready to work with Xilinx ${bold}${branch:7:6}${normal} release branch:"
    echo ""
    echo "    Xilinx Board Utility (xbutil)       : ${bold}$XILINX_XRT/bin${normal}"
    echo "    Xilinx Tools (Vivado, Vitis_HLS)    : ${bold}/tools/Xilinx${normal}"
else
    echo "The server needs special care to operate with XRT normally (Xilinx tools are not properly installed)."
    echo ""
    echo "${bold}An email has been sent to the person in charge;${normal} we will let you know when XRT is ready to use again."
    echo "Subject: $hostname requires special attention ($username): Xilinx tools are not properly installed" | sendmail $email
fi

echo ""