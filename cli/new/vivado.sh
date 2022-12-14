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

# create vivado directory
DIR="/home/$username/my_projects/vivado"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# copy vivado common folder
#DIR="/home/$username/my_projects/vivado/common"
#if ! [ -d "$DIR" ]; then
#    cp -rf /opt/cli/templates/vivado/common/ $DIR
#fi

# create project
echo ""
echo "${bold}sgutil new vivado${normal}"
echo ""
echo "Please, insert a non-existing name for your Vivado project:"
echo ""
while true; do
    read -p "" project_name
    DIR="/home/$username/my_projects/vivado/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        # copy
        # cp -rf /opt/cli/templates/vivado/hello_world/* $DIR
        cd /home/$username/my_projects/vivado/$project_name
        touch complete.copy
        break
    fi
done
echo ""
echo "The project /home/$username/my_projects/vivado/$project_name has been created!"
echo ""