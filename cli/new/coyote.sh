#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
WORKFLOW="coyote"

#get username
username=$USER

echo ""
echo "${bold}sgutil new coyote${normal}"

#check for vivado_developers
member=$($CLI_PATH/common/is_member $username vivado_developers)
if [ "$member" = "false" ]; then
    echo ""
    echo "Sorry, ${bold}$username!${normal} You are not granted to use this command."
    echo ""
    exit
fi

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create coyote directory
DIR="/home/$username/my_projects/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create project
echo ""
echo "Please, insert a non-existing name for your Coyote project:"
echo ""
while true; do
    read -p "" project_name
    #project_name cannot start with validate_
    if  [[ $project_name == validate_* ]]; then
        project_name=""
    fi
    DIR="/home/$username/my_projects/$WORKFLOW/$project_name"
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
        #copy template
        cp -rf $CLI_PATH/templates/$WORKFLOW/hello_world/* $DIR
        #replace Makefile (main.cpp specific version)
        rm $DIR/sw/CMakeLists.txt
        mv $DIR/CMakeLists.txt $DIR/sw
        #compile create config
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        break
    fi
done
echo ""
echo "The project /home/$username/my_projects/$WORKFLOW/$project_name has been created!"
echo ""