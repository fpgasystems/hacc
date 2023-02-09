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

name_found="0"
for (( i=0; i<${#flags[@]}; i++ ))
do
    if [[ " ${flags[$i]} " =~ " -n " ]] || [[ " ${flags[$i]} " =~ " --name " ]]; then 
        name_found="1"
        name_idx=$(($i+1))
        device_name=${flags[$name_idx]}
    fi
done

echo ""
echo "${bold}sgutil build coyote${normal}"
echo ""
echo "Please, choose Coyote's configuration:" # this refers to a software (sw/examples) configuration
echo ""
PS3=""
select config in perf_host perf_fpga perf_mem gbm_dtrees hyperloglog #perf_host perf_fpga gbm_dtrees hyperloglog perf_dram perf_hbm perf_mem perf_rdma perf_rdma_host perf_rdma_card perf_tcp rdma_regex service_aes service_reconfiguration
do
    case $config in
        perf_host) break;;                  #1
        perf_fpga) break;;                  #2
        perf_mem) break;;                   #7
        gbm_dtrees) break;;                 #3
        hyperloglog) break;;                #4
    esac
done
# perf_host) break;;                  #1
# perf_fpga) break;;                  #2
# gbm_dtrees) break;;                 #3
# hyperloglog) break;;                #4
# perf_dram) break;;                  #5
# perf_hbm) break;;                   #6
# perf_mem) break;;                   #7
# perf_rdma) break;;                  #7  #8
# perf_rdma_host) break;;             #8  #9
# perf_rdma_card) break;;             #9  #10
# perf_tcp) break;;                   #10 #11
# rdma_regex) break;;                 #11 #12
# service_aes) break;;                #12 #13
# service_reconfiguration) break;;    #13 #14

#sgutil get device if there is only one FPGA and not name_found
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]] & [[ $name_found = "0" ]]; then
    device_name=$(sgutil get device | cut -d "=" -f2)
fi

# device_name to coyote string <===========================================================================
FDEV_NAME=$(echo $HOSTNAME | grep -oP '(?<=-).*?(?=-)')
if [ "$FDEV_NAME" = "u50d" ]; then
    FDEV_NAME="u50"
fi
#echo "-------------"
#echo "$FDEV_NAME"
#echo "-------------"

# set project name
project_name="validate_$config.$device_name"

#define directories
DIR="/home/$username/my_projects/coyote/$project_name"
BUILD_DIR="/home/$username/my_projects/coyote/$project_name/hw/build"
DRIVER_DIR="/home/$username/my_projects/coyote/$project_name/driver"
APP_DIR="/home/$username/my_projects/coyote/$project_name/sw/examples/$config/build"

# adjust perf_mem validation
if [ "$config" = "perf_mem" ]; then
    case "$FDEV_NAME" in
        u250) 
            config_hw="perf_dram"
            ;;
        u280) 
            config_hw="perf_hbm"
            ;;
        u50)
            config_hw="perf_hbm"
            ;;
        u55c)
            config_hw="perf_hbm"
            ;; 
        *)
            echo ""
            echo "Unknown device name."
            echo ""
        ;;  
    esac
else
    config_hw=$config
fi
#echo "-------------"
#echo "$config"
#echo "$config_hw"
#echo "-------------"

# create coyote validate config.device_name directory and checkout
#DIR="/home/$username/my_projects/coyote/$project_name"
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
    #build="1"
    #break

    # create configuration file
    touch config.cpp
    case "$config_hw" in #config
        perf_host) 
            echo "const int EN_HLS = 0;" > config.cpp
            echo "const int EN_MEM = 0;" >> config.cpp
            echo "const int EN_STRM = 1;" >> config.cpp
            echo "const int EN_MEM = 0;" >> config.cpp
            echo "const int N_REGIONS = 3;" >> config.cpp
            ;;
        perf_fpga)
            echo "const int EN_HLS = 0;" > config.cpp
            echo "const int EN_BPSS = 1;" >> config.cpp
            echo "const int EN_STRM = 1;" >> config.cpp
            echo "const int EN_MEM = 0;" >> config.cpp
            echo "const int EN_WB = 1;" >> config.cpp
            ;;
        perf_hbm)
            echo "const int N_REGIONS = 4;" > config.cpp
            echo "const int EN_HLS = 0;" >> config.cpp
            echo "const int EN_STRM = 0;" >> config.cpp
            echo "const int EN_MEM = 1;" >> config.cpp
            ;;
        perf_dram)
            echo "const int N_REGIONS = 4;" > config.cpp
            echo "const int EN_HLS = 0;" >> config.cpp
            echo "const int EN_STRM = 0;" >> config.cpp
            echo "const int EN_MEM = 1;" >> config.cpp
            echo "const int N_DDR_CHAN = 2;" >> config.cpp
            ;;
        gbm_dtrees) 
            echo "const int EN_HLS = 0;" > config.cpp
            echo "const int EN_STRM = 1;" >> config.cpp
            echo "const int EN_MEM = 0;" >> config.cpp
            ;;
        hyperloglog) 
            echo "const int EN_HLS = 1;" > config.cpp
            echo "const int EN_STRM = 1;" >> config.cpp
            echo "const int EN_MEM = 0;" >> config.cpp
            ;;
        #perf_dram) 
        #    echo "const int N_REGIONS = 4;" > config.cpp
        #    echo "const int EN_HLS = 0;" >> config.cpp
        #    echo "const int EN_STRM = 0;" >> config.cpp
        #    echo "const int EN_MEM = 1;" >> config.cpp
        #    echo "const int N_DDR_CHAN = 2;" >> config.cpp
        #    ;;
        *)
            echo ""
            echo "Unknown configuration."
            echo ""
        ;;  
    esac

    #bitstream compilation
    #BUILD_DIR="/home/$username/my_projects/coyote/$project_name/hw/build"
    echo ""
    echo "${bold}Coyote shell compilation:${normal}"
    echo ""
    echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw"
    echo ""
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    /usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw #$config

    #generate bitstream
    echo ""
    echo "${bold}Coyote shell bitstream generation:${normal}"
    echo ""
    echo "make shell && make compile"
    echo ""
    make shell && make compile

    #driver compilation
    #DRIVER_DIR="/home/$username/my_projects/coyote/$project_name/driver"
    echo ""
    echo "${bold}Driver compilation:${normal}"
    echo ""
    echo "cd $DRIVER_DIR && make"
    echo ""
    cd $DRIVER_DIR && make

    #application compilation
    #APP_DIR="/home/$username/my_projects/coyote/$project_name/sw/examples/$config/build" #build_dir.sw_$config
    echo ""
    echo "${bold}Example application compilation:${normal}"
    echo ""
    echo "cmake ../ -DTARGET_DIR=../examples/$config && make"
    echo ""
    if ! [ -d "$APP_DIR" ]; then
        mkdir $APP_DIR
    fi
    cd $APP_DIR
    /usr/bin/cmake ../../../ -DTARGET_DIR=examples/$config && make
else
    echo ""
    echo "$project_name already exists!"
    #echo ""
fi



#if ! [ -d "$BUILD_DIR" ]; then
    
#else
#    echo "${bold}Bitstream compilation and generation:${normal}"
#    echo ""
#    echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config"
#    echo "make shell && make compile"
#    echo ""
#    echo "$BUILD_DIR already exists!"
#    #exit
#fi

# revert to xrt first if FPGA is already in baremetal
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then
    /opt/cli/program/revert
fi

# program
/opt/cli/sgutil program coyote -p $project_name

# get N_REGIONS
cd ${DIR}
N_REGIONS=$(grep -n "N_REGIONS" config.cpp | sed 's/.*=//' | sed 's/;//')
if [ "$N_REGIONS" = "" ]; then
    N_REGIONS="1"
fi

# get fpga_chmod for the total of regions (0 is already assigned)
N_REGIONS=$(($N_REGIONS-1));
for (( i = 1; i <= $N_REGIONS; i++ ))
do 
   sudo /opt/cli/program/fpga_chmod $i
done

# run 
#DIR="/home/$username/my_projects/coyote/$project_name/sw/examples/$config/build"
cd /home/$username/my_projects/coyote/$project_name/sw/examples/$config/build #${DIR}
./main