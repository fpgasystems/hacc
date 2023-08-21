#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
XILINX_PLATFORMS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_PLATFORMS_PATH)
XRT_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XRT_PATH)
XILINX_TOOLS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH XILINX_TOOLS_PATH)
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="vitis"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

#check on valid XRT and Vivado version
if [ -z "$(echo $XILINX_XRT)" ] || [ -z "$(echo $XILINX_VIVADO)" ]; then
    echo ""
    echo "Please, source a valid XRT and Vitis version for ${bold}$hostname!${normal}"
    echo ""
    exit 1
fi

#check if workflow exists
if ! [ -d "$MY_PROJECTS_PATH/$WORKFLOW/" ]; then
    echo ""
    echo "You must create your project first! Please, use sgutil new vitis"
    echo ""
    exit
fi

#inputs
read -a flags <<< "$@"

#check on flags
project_found=""
project_name=""
target_found=""
target_name=""
platform_found=""
platform_name=""
if [ "$flags" = "" ]; then
    #header (1/2)
    echo ""
    echo "${bold}sgutil build vitis${normal}"
    #project_dialog
    echo ""
    echo "${bold}Please, choose your $WORKFLOW project:${normal}"
    echo ""
    result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW) #$USER $WORKFLOW
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    multiple_projects=$(echo "$result" | sed -n '3p')
    if [[ $multiple_projects = "0" ]]; then
        echo $project_name
    fi
    #target_dialog
    echo ""
    echo "${bold}Please, choose binary's execution target:${normal}"
    echo ""
    target_name=$($CLI_PATH/common/target_dialog)
    #platform_dialog
    echo ""
    echo "${bold}Please, choose your platform:${normal}"
    echo ""
    result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
    platform_found=$(echo "$result" | sed -n '1p')
    platform_name=$(echo "$result" | sed -n '2p')
    multiple_platforms=$(echo "$result" | sed -n '3p')
    if [[ $multiple_platforms = "0" ]]; then
        echo $platform_name
    fi
else
    #project_dialog_check
    result="$("$CLI_PATH/common/project_dialog_check" "${flags[@]}")"
    project_found=$(echo "$result" | sed -n '1p')
    project_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [ "$project_found" = "1" ] && ([ "$project_name" = "" ] || [ ! -d "$MY_PROJECTS_PATH/$WORKFLOW/$project_name" ]); then 
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #target_dialog_check
    result="$("$CLI_PATH/common/target_dialog_check" "${flags[@]}")"
    target_found=$(echo "$result" | sed -n '1p')
    target_name=$(echo "$result" | sed -n '2p')
    #forbidden combinations
    if [[ "$target_found" = "1" && ! ( "$target_name" = "sw_emu" || "$target_name" = "hw_emu" || "$target_name" = "hw" ) ]]; then
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #platform_dialog_check
    result="$("$CLI_PATH/common/platform_dialog_check" "${flags[@]}")"
    platform_found=$(echo "$result" | sed -n '1p')
    platform_name=$(echo "$result" | sed -n '2p')    
    #forbidden combinations
    if ([ "$platform_found" = "1" ] && [ "$platform_name" = "" ]) || ([ "$platform_found" = "1" ] && [ ! -d "$XILINX_PLATFORMS_PATH/$platform_name" ]); then
        $CLI_PATH/sgutil build vitis -h
        exit
    fi
    #header (2/2)
    echo ""
    echo "${bold}sgutil build vitis${normal}"
    #project_dialog (forgotten mandatory 1)
    if [[ $project_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your $WORKFLOW project:${normal}"
        echo ""
        result=$($CLI_PATH/common/project_dialog $MY_PROJECTS_PATH/$WORKFLOW) #$USER $WORKFLOW
        project_found=$(echo "$result" | sed -n '1p')
        project_name=$(echo "$result" | sed -n '2p')
        multiple_projects=$(echo "$result" | sed -n '3p')
        if [[ $multiple_projects = "0" ]]; then
            echo $project_name
        fi
    fi
    #target_dialog (forgotten mandatory 3)
    if [[ $target_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose binary's execution target:${normal}"
        echo ""
        target_name=$($CLI_PATH/common/target_dialog)
    fi
    #platform_dialog (forgotten mandatory 2)
    if [[ $platform_found = "0" ]]; then
        echo ""
        echo "${bold}Please, choose your platform:${normal}"
        echo ""
        result=$($CLI_PATH/common/platform_dialog $XILINX_PLATFORMS_PATH)
        platform_found=$(echo "$result" | sed -n '1p')
        platform_name=$(echo "$result" | sed -n '2p')
        multiple_platforms=$(echo "$result" | sed -n '3p')
        if [[ $multiple_platforms = "0" ]]; then
            echo $platform_name
        fi
    fi
fi

#define directories (1)
DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"

#check for project directory
if ! [ -d "$DIR" ]; then
    echo ""
    echo "$DIR is not a valid --project name!"
    echo ""
    exit
fi

#create or select a configuration
cd $DIR/configs/
if [[ $(ls -l | wc -l) = 2 ]]; then
    #only config_000 exists and we create config_kernel and config_001
    #we compile create_config (in case there were changes)
    cd $DIR/src
    g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
    cd $DIR
    ./create_config
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
elif [[ $(ls -l | wc -l) = 5 ]]; then
    #config_000, config_kernel and config_001 exist
    cp -fr $DIR/configs/config_001.hpp $DIR/configs/config_000.hpp
    config="config_001.hpp"
    echo ""
elif [[ $(ls -l | wc -l) > 5 ]]; then
    cd $DIR/configs/
    configs=( "config_"*.hpp )
    echo ""
    echo "${bold}Please, choose your configuration:${normal}"
    echo ""
    PS3=""
    select config in "${configs[@]:1:${#configs[@]}-2}"; do # with :1 we avoid config_000.hpp and then config_kernel.hpp
        if [[ -z $config ]]; then
            echo "" >&/dev/null
        else
            break
        fi
    done
    # copy selected config as config_000.hpp
    cp -fr $DIR/configs/$config $DIR/configs/config_000.hpp
    echo ""
fi

#save config id
cd $DIR/configs/
if [ -e config_*.active ]; then
    rm *.active
fi
config_id="${config%%.*}"
touch $config_id.active

#define directories (2)
APP_BUILD_DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name/build_dir.$target_name.$platform_name"

echo ""
echo "${bold}Changing directory:${normal}"
echo ""
echo "cd $DIR"
echo ""
cd $DIR

#compilation
if ! [ -d "$APP_BUILD_DIR" ]; then
    # APP_BUILD_DIR does not exist
    export CPATH="/usr/include/x86_64-linux-gnu" #https://support.xilinx.com/s/article/Fatal-error-sys-cdefs-h-No-such-file-or-directory?language=en_US
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target_name PLATFORM=$platform_name" 
    echo ""
    eval "make all TARGET=$target_name PLATFORM=$platform_name"
    echo ""        

    #send email at the end
    if [ "$target_name" = "hw" ]; then
        user_email=$USER@ethz.ch
        echo "Subject: Good news! sgutil build vitis ($project_name / TARGET=$target_name / PLATFORM=$platform_name) is done!" | sendmail $user_email
    fi
    
else
    echo "${bold}PL kernel compilation and linking: generating .xo and .xclbin:${normal}"
    echo ""
    echo "make all TARGET=$target_name PLATFORM=$platform_name" 
    echo ""
    echo "$APP_BUILD_DIR already exists!"
    echo ""

    #get xrt version
    branch=$($XRT_PATH/bin/xbutil --version | grep -i -w 'Branch' | tr -d '[:space:]')
    branch=${branch:7:6}
    
    #application compilation
    echo "${bold}Application compilation:${normal}"
    echo ""
    #openCL
    #echo "g++ -o $project_name $MY_PROJECTS_PATH/$WORKFLOW/common/includes/xcl2/xcl2.cpp src/host.cpp -I$XRT_PATH/include -I$XILINX_TOOLS_PATH//Vivado/$branch/include -Wall -O0 -g -std=c++1y -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/xcl2 -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++"
    #g++ -o $project_name $MY_PROJECTS_PATH/$WORKFLOW/common/includes/xcl2/xcl2.cpp src/host.cpp -I$XRT_PATH/include -I$XILINX_TOOLS_PATH//Vivado/$branch/include -Wall -O0 -g -std=c++1y -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/xcl2 -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++
    #xrt native
    echo "g++ -o $project_name $MY_PROJECTS_PATH/$WORKFLOW/common/includes/cmdparser/cmdlineparser.cpp $MY_PROJECTS_PATH/$WORKFLOW/common/includes/logger/logger.cpp src/host.cpp -I$XRT_PATH/include -I$XILINX_VIVADO/include -Wall -O0 -g -std=c++1y -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/cmdparser -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/logger -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++  -luuid -lxrt_coreutil"
    g++ -o $project_name $MY_PROJECTS_PATH/$WORKFLOW/common/includes/cmdparser/cmdlineparser.cpp $MY_PROJECTS_PATH/$WORKFLOW/common/includes/logger/logger.cpp src/host.cpp -I$XRT_PATH/include -I$XILINX_VIVADO/include -Wall -O0 -g -std=c++1y -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/cmdparser -I$MY_PROJECTS_PATH/$WORKFLOW/common/includes/logger -fmessage-length=0 -L$XRT_PATH/lib -pthread -lOpenCL -lrt -lstdc++  -luuid -lxrt_coreutil
    echo ""
    
fi