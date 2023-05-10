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

# create hip directory
DIR="/home/$username/my_projects/hip"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create project
echo ""
echo "${bold}sgutil new hip${normal}"
echo ""
echo "Please, insert a non-existing name for your HIP project:"
echo ""
while true; do
    read -p "" project_name
    #project_name cannot start with validate_
    if  [[ $project_name == validate_* ]]; then
        project_name=""
    fi
    DIR="/home/$username/my_projects/hip/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        # copy
        cp -rf /opt/cli/templates/hip/hello_world/* $DIR
        # we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
        #rm $DIR/makefile_versal_ps.mk
        #rm $DIR/makefile_zynq7000.mk
        #rm $DIR/makefile_zynqmp.mk
        # adjust Makefile
        #sed -i "s/hello_world/$project_name/" $DIR/Makefile
        #sed -i "s/hello_world/$project_name/" $DIR/makefile_us_alveo.mk
        #sed -i "s/hello_world/$project_name/" $DIR/makefile_versal_alveo.mk
        #compile src
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        #g++ -std=c++17 create_data.cpp -o ../create_data
        break
    fi
done
echo ""
echo "The project /home/$username/my_projects/hip/$project_name has been created!"
echo ""