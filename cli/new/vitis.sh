#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
MY_PROJECTS_PATH="/home/$USER/my_projects"
WORKFLOW="vitis"

# create my_projects directory
DIR="$MY_PROJECTS_PATH"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create vitis directory
DIR="$MY_PROJECTS_PATH/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# copy vitis common folder
DIR="$MY_PROJECTS_PATH/$WORKFLOW/common"
if ! [ -d "$DIR" ]; then
    cp -rf $CLI_PATH/templates/$WORKFLOW/common/ $DIR
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
        # copy
        cp -rf $CLI_PATH/templates/$WORKFLOW/hello_world/* $DIR
        # we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
        rm $DIR/makefile_versal_ps.mk
        rm $DIR/makefile_zynq7000.mk
        rm $DIR/makefile_zynqmp.mk
        # adjust Makefile
        sed -i "s/hello_world/$project_name/" $DIR/Makefile
        sed -i "s/hello_world/$project_name/" $DIR/makefile_us_alveo.mk
        sed -i "s/hello_world/$project_name/" $DIR/makefile_versal_alveo.mk
        #compile src
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        break
    fi
done
echo ""
echo "The project $MY_PROJECTS_PATH/$WORKFLOW/$project_name has been created!"
echo ""