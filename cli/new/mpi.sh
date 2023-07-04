#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_PATH="/opt/cli"
MY_PROJECTS_PATH="/home/$USER/my_projects"
WORKFLOW="mpi"

#constants
PROCESSES_PER_HOST=2

# create my_projects directory
DIR="/home/$USER/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create mpi directory
DIR="/home/$USER/my_projects/$WORKFLOW"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create project
echo ""
echo "${bold}sgutil new mpi${normal}"
echo ""
echo "Please, insert a non-existing name for your MPI project:"
echo ""
while true; do
    read -p "" project_name
    #project_name cannot start with validate_
    if  [[ $project_name == validate_* ]]; then
        project_name=""
    fi
    DIR="/home/$USER/my_projects/$WORKFLOW/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir $DIR
        #copy template
        cp -rf $CLI_PATH/templates/$WORKFLOW/hello_world/* $DIR
        #compile create config
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        #create hosts file (it will create it with the current booked servers)
        echo ""
        servers=$(sudo $CLI_PATH/common/get_booking_system_servers_list | tail -n +2) #get booked machines
        servers=($servers) #convert string to an array
        cd $DIR
        rm hosts
        touch hosts
        j=0
        for i in "${servers[@]}"
        do
            if [ "$i" != "$hostname" ]; then
                echo "$i-mellanox-0:$PROCESSES_PER_HOST" >> hosts
                ((j=j+1))
            fi
        done
        break
    fi
done
echo ""
echo "The project /home/$USER/my_projects/$WORKFLOW/$project_name has been created!"
echo ""