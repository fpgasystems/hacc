#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create vitis directory
DIR="/home/$username/my_projects/vitis"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# copy vitis common folder
DIR="/home/$username/my_projects/vitis/common"
if ! [ -d "$DIR" ]; then
    cp -rf /opt/cli/templates/vitis/common/ $DIR
fi

# create project
echo ""
echo "${bold}sgutil new vitis${normal}"
echo ""
echo "Please, insert a non-existing name for your Vitis project:"
echo ""
while true; do
    read -p "" project_name
    DIR="/home/$username/my_projects/vitis/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        # copy
        cp -rf /opt/cli/templates/vitis/hello_world/* $DIR
        # we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
        rm $DIR/makefile_versal_ps.mk
        rm $DIR/makefile_zynq7000.mk
        rm $DIR/makefile_zynqmp.mk
        # adjust Makefile
        sed -i "s/hello_world/$project_name/" $DIR/Makefile
        sed -i "s/hello_world/$project_name/" $DIR/makefile_us_alveo.mk
        sed -i "s/hello_world/$project_name/" $DIR/makefile_versal_alveo.mk
        break
    fi
done
echo ""
echo "The project /home/$username/my_projects/vitis/$project_name has been created!"
echo ""