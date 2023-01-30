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

name_found="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then 
        name_found="1"
        name_idx=$(($i+1))
        device_name=${flags[$name_idx]}
    fi
done

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

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

# device_name to coyote string <===========================================================================
case "$device_name" in
    xcu250_0) 
        FDEV_NAME="u250"
        ;;
    xcu50_u55n_0)
        FDEV_NAME="u50"
        ;;
    xcu280_u55c_0) 
        FDEV_NAME="u55c"
        ;;
    *)
        echo ""
        echo "Unknown device name."
        echo ""
    ;;  
esac

# create coyote validate config.device_name directory and checkout
DIR="/home/$username/my_projects/coyote/validate_$config.$device_name"
#build="0"
if ! [ -d "$DIR" ]; then
    mkdir ${DIR}
    echo ""
    echo "${bold}Checking out Coyote:${normal}"
    echo ""
    cd ${DIR}
    git clone https://github.com/fpgasystems/Coyote.git
    mv Coyote/* .
    rm -rf Coyote
    build="1"
    break
fi

# create configuration file
cd ${DIR}
touch config.cpp
case "$config" in
    perf_host) 
        echo "const int EN_HLS = 0;" > config.cpp
        echo "const int EN_MEM = 0;" >> config.cpp
        echo "const int EN_STRM = 1;" >> config.cpp
        echo "const int EN_MEM = 0;" >> config.cpp
        echo "const int N_REGIONS = 3;" >> config.cpp
        declare -i N_REGIONS=3
        ;;
    perf_fpga)
        #...
        ;;
    gbm_dtrees) 
        #...
        ;;
    *)
        echo ""
        echo "Unknown configuration."
        echo ""
    ;;  
esac

# build project
if [ "$build" = "1" ]; then
    /opt/cli/sgutil build coyote -p validate_$config.$device_name
fi

# program
/opt/cli/sgutil program coyote -p validate_$config.$device_name

# get fpga_chmod for the total of regions (0 is already assigned)
N_REGIONS=$(($N_REGIONS-1));
for (( i = 1; i <= $N_REGIONS; i++ ))
do 
   sudo /opt/cli/program/fpga_chmod $i
done

# run 
DIR="/home/$username/my_projects/coyote/validate_$config.$device_name/sw/examples/$config/build"
./main