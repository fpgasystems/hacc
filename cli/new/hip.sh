#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="$(dirname "$(dirname "$0")")"
MY_PROJECTS_PATH=$($CLI_PATH/common/get_path $CLI_PATH MY_PROJECTS_PATH)
WORKFLOW="hip"

#get hostname
url="${HOSTNAME}"
hostname="${url%%.*}"

# create my_projects directory
DIR="$MY_PROJECTS_PATH"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create hip directory
DIR="$MY_PROJECTS_PATH/$WORKFLOW"
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
    DIR="$MY_PROJECTS_PATH/$WORKFLOW/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir ${DIR}
        # copy
        cp -rf $CLI_PATH/templates/$WORKFLOW/hello_world/* $DIR
        #compile src
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        #g++ -std=c++17 create_data.cpp -o ../create_data
        break
    fi
done
echo ""
echo "The project $MY_PROJECTS_PATH/$WORKFLOW/$project_name has been created!"
echo ""