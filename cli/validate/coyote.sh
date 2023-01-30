#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#get username
username=$USER

# inputs
read -a flags <<< "$@"

# flags cannot be empty ==> they can!
#if [ "$flags" = "" ]; then
#    /opt/cli/sgutil build coyote -h
#    exit
#fi

# create my_projects directory
DIR="/home/$username/my_projects"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create coyote directory
DIR="/home/$username/my_projects/coyote"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

# create coyote validate directory
DIR="/home/$username/my_projects/coyote/validate"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
fi

echo ""
echo "${bold}sgutil build coyote${normal}"
echo ""
echo "Please, choose Coyote's configuration:"
echo ""
PS3=""
select config in perf_host perf_fpga gbm_dtrees hyperloglog perf_dram perf_hbm perf_rdma_host perf_rdma_card perf_tcp rdma_regex service_aes service_reconfiguration
do
    case $config in
        perf_host) break;;
        perf_fpga) break;;
        gbm_dtrees) break;;
        hyperloglog) break;;
        perf_dram) break;;
        perf_hbm) break;;
        perf_rdma_host) break;;
        perf_rdma_card) break;;
        perf_tcp) break;;
        rdma_regex) break;;
        service_aes) break;;
        service_reconfiguration) break;;
    esac
done

# create coyote validate config directory
DIR="/home/$username/my_projects/coyote/validate/$config"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}

else
    echo "project already exists."
fi