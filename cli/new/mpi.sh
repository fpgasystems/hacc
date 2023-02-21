#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
PROCESSES_PER_HOST=2

#get username
username=$USER

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create mpi directory
DIR="/home/$username/my_projects/mpi"
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
    DIR="/home/$username/my_projects/mpi/$project_name"
    if ! [ -d "$DIR" ]; then
        # project_name does not exist
        mkdir $DIR
        # clone repository
        #echo ""
        #echo "${bold}Checking out Coyote:${normal}"
        #echo ""
        #   cd ${DIR}
        #git clone https://github.com/fpgasystems/Coyote.git
        #mv Coyote/* .
        #rm -rf Coyote
        #copy template
        cp -rf /opt/cli/templates/mpi/hello_world/* $DIR
        #replace Makefile (main.cpp specific version)
        #rm $DIR/sw/CMakeLists.txt
        #mv $DIR/CMakeLists.txt $DIR/sw
        #compile create config
        cd $DIR/src
        g++ -std=c++17 create_config.cpp -o ../create_config >&/dev/null
        #create hosts file (it will create it with the current booked servers)
        #echo "${bold}Creating hosts file:${normal}"
        #echo ""
        #sleep 1
        servers=$(sudo /opt/cli/common/get_booking_system_servers_list | tail -n +2) #get booked machines
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
echo "The project /home/$username/my_projects/mpi/$project_name has been created!"
echo ""