#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#echo ""
#echo "${bold}iperf${normal}"
#echo ""

#echo "user is: $USER"

#get username
username=$USER
#echo "Usuari: $username"

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
#else
#    echo "already exists"
fi

# create coyote directory
DIR="/home/$username/my_projects/coyote"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
#else
#    echo "already exists"
fi

# create project
echo ""
echo "${bold}sgutil new coyote${normal}"
echo ""
echo "Please, insert a non-existing name for your Coyote project:"
echo ""
while true; do
    read -p "" project_name
    DIR="/home/$username/my_projects/coyote/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        # clone repository
        echo ""
        echo "${bold}Checking out Coyote:${normal}"
        echo ""
        cd ${DIR}
        git clone https://github.com/fpgasystems/Coyote.git
        mv Coyote/* .
        rm -rf Coyote
        #cp -rf /opt/cli/templates/coyote/hello_world/* $DIR
        # we only need makefile_us_alveo.mk (for alveos) and makefile_versal_alveo.mk (for versal)
        #rm $DIR/makefile_versal_ps.mk
        #rm $DIR/makefile_zynq7000.mk
        #rm $DIR/makefile_zynqmp.mk
        # adjust Makefile
        #sed -i "s/hello_world/$project_name/" $DIR/Makefile
        #sed -i "s/hello_world/$project_name/" $DIR/makefile_us_alveo.mk
        #sed -i "s/hello_world/$project_name/" $DIR/makefile_versal_alveo.mk
        break
    fi
done
echo ""
echo "The project /home/$username/my_projects/coyote/$project_name has been created!"
echo ""