#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
MY_PROJECTS_PATH=$($CLI_PATH/common/get_constant $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="vitis"
TEMPLATE_NAME="hello_world_xrt"

# create my_projects directory
DIR="$MY_PROJECTS_PATH"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create vitis directory
VITIS_DIR="$MY_PROJECTS_PATH/$WORKFLOW"
if ! [ -d "$VITIS_DIR" ]; then
    mkdir ${VITIS_DIR}
fi

#prepare for wget (1)
if [ -d "$VITIS_DIR/common" ]; then
    rm -rf "$VITIS_DIR/common"
fi

#prepare for wget (2)
if [ -d "$VITIS_DIR/tmp" ]; then
    rm -rf "$VITIS_DIR/tmp"
fi

# create project
echo ""
echo "${bold}sgutil new vitis${normal}"
echo ""
echo "Please, insert a non-existing name for your Vitis project:"
echo ""
while true; do
    read -p "" project_name
    #project_name cannot start with validate_
    if  [[ $project_name == validate_* ]]; then
        project_name=""
    fi
    DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        #copy vitis common folder from Vitis_Accel_Examples repository (wget)
        echo ""
        echo "${bold}Checking out Vitis_Accel_Examples/common:${normal}"
        echo ""
        wget https://github.com/Xilinx/Vitis_Accel_Examples/archive/master.zip -O $VITIS_DIR/master.zip
        mkdir $VITIS_DIR/tmp
        unzip -q $VITIS_DIR/master.zip -d $VITIS_DIR/tmp
        mv -f $VITIS_DIR/tmp/Vitis_Accel_Examples-master/common $VITIS_DIR
        rm -rf $VITIS_DIR/tmp
        rm $VITIS_DIR/master.zip
        #copy
        cp -rf $CLI_PATH/templates/$WORKFLOW/$TEMPLATE_NAME/* $DIR
        # we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
        rm $DIR/makefile_versal_ps.mk
        #rm $DIR/makefile_zynq7000.mk
        rm $DIR/makefile_zynqmp.mk
        # adjust Makefile
        sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/Makefile
        sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/makefile_us_alveo.mk
        sed -i "s/$TEMPLATE_NAME/$project_name/" $DIR/makefile_versal_alveo.mk
        #compile src
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        break
    fi
done
#echo ""
echo "The project $VITIS_DIR/$project_name ($TEMPLATE_NAME) has been created!"
echo ""