#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
BIT_NAME="cyt_top.bit"
DRIVER_NAME="coyote_drv.ko"

#get username
username=$USER

# inputs
read -a flags <<< "$@"

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

# device_name to coyote string
FDEV_NAME=$(echo $HOSTNAME | grep -oP '(?<=-).*?(?=-)')
if [ "$FDEV_NAME" = "u50d" ]; then
    FDEV_NAME="u50"
fi

# set project name
project_name="validate_$config.$device_name"

#define directories (1)
DIR="/home/$username/my_projects/coyote/$project_name"
SHELL_BUILD_DIR="$DIR/hw/build"
DRIVER_DIR="$DIR/driver"
APP_BUILD_DIR="$DIR/sw/examples/$config/build"

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

# create coyote validate config.device_name directory and checkout
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
    touch config_shell.hpp
    case "$config_hw" in #config
        perf_host) 
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int N_REGIONS = 3;" >> config_shell.hpp
            ;;
        perf_fpga)
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_BPSS = 1;" >> config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            echo "const int EN_WB = 1;" >> config_shell.hpp
            ;;
        perf_hbm)
            echo "const int N_REGIONS = 4;" > config_shell.hpp
            echo "const int EN_HLS = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 0;" >> config_shell.hpp
            echo "const int EN_MEM = 1;" >> config_shell.hpp
            ;;
        perf_dram)
            echo "const int N_REGIONS = 4;" > config_shell.hpp
            echo "const int EN_HLS = 0;" >> config_shell.hpp
            echo "const int EN_STRM = 0;" >> config_shell.hpp
            echo "const int EN_MEM = 1;" >> config_shell.hpp
            echo "const int N_DDR_CHAN = 2;" >> config_shell.hpp
            ;;
        gbm_dtrees) 
            echo "const int EN_HLS = 0;" > config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            ;;
        hyperloglog) 
            echo "const int EN_HLS = 1;" > config_shell.hpp
            echo "const int EN_STRM = 1;" >> config_shell.hpp
            echo "const int EN_MEM = 0;" >> config_shell.hpp
            ;;
        #perf_dram) 
        #    echo "const int N_REGIONS = 4;" > config_shell.hpp
        #    echo "const int EN_HLS = 0;" >> config_shell.hpp
        #    echo "const int EN_STRM = 0;" >> config_shell.hpp
        #    echo "const int EN_MEM = 1;" >> config_shell.hpp
        #    echo "const int N_DDR_CHAN = 2;" >> config_shell.hpp
        #    ;;
        *)
            echo ""
            echo "Unknown configuration."
            echo ""
        ;;  
    esac
    mkdir $DIR/configs
    mv $DIR/config_shell.hpp $DIR/configs/config_shell.hpp
else
    echo ""
    echo "$project_name already exists!"
fi

#check on build_dir.FDEV_NAME
if ! [ -d "/home/$username/my_projects/coyote/$project_name/build_dir.$FDEV_NAME" ]; then
    #bitstream compilation
    echo ""
    echo "${bold}Coyote shell compilation:${normal}"
    echo ""
    echo "cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw"
    echo ""
    mkdir $SHELL_BUILD_DIR
    cd $SHELL_BUILD_DIR
    /usr/bin/cmake .. -DFDEV_NAME=$FDEV_NAME -DEXAMPLE=$config_hw #$config

    #generate bitstream
    echo ""
    echo "${bold}Coyote shell bitstream generation:${normal}"
    echo ""
    echo "make shell && make compile"
    echo ""
    make shell && make compile

    #driver compilation
    echo ""
    echo "${bold}Driver compilation:${normal}"
    echo ""
    echo "cd $DRIVER_DIR && make"
    echo ""
    cd $DRIVER_DIR && make

    #application compilation
    echo ""
    echo "${bold}Example application compilation:${normal}"
    echo ""
    echo "cmake ../ -DTARGET_DIR=../examples/$config && make"
    echo ""
    if ! [ -d "$APP_BUILD_DIR" ]; then
        mkdir $APP_BUILD_DIR
    fi
    cd $APP_BUILD_DIR
    /usr/bin/cmake ../../../ -DTARGET_DIR=examples/$config && make
    #copy bitstream
    cp $SHELL_BUILD_DIR/bitstreams/cyt_top.bit $APP_BUILD_DIR
    #copy driver
    cp $DRIVER_DIR/coyote_drv.ko $APP_BUILD_DIR
    #rename folder
    mv $APP_BUILD_DIR /home/$username/my_projects/coyote/$project_name/build_dir.$FDEV_NAME/
    #remove all other build temporal folders
    rm -rf $SHELL_BUILD_DIR
    rm $DRIVER_DIR/coyote_drv*
    rm $DRIVER_DIR/fpga_dev.o
    rm $DRIVER_DIR/fpga_drv.o
    rm $DRIVER_DIR/fpga_fops.o
    rm $DRIVER_DIR/fpga_isr.o
    rm $DRIVER_DIR/fpga_mmu.o
    rm $DRIVER_DIR/fpga_sysfs.o
    rm $DRIVER_DIR/modules.order
else
    echo ""
    echo "$project_name/build_dir.$FDEV_NAME shell already exists!"
    #echo ""
fi

#define directories (2)
APP_BUILD_DIR=/home/$username/my_projects/coyote/$project_name/build_dir.$FDEV_NAME/

#program coyote bitstream
/opt/cli/program/vivado -b $APP_BUILD_DIR$BIT_NAME

#show message for virtualized environment (after program/vivado shows go to baremetal/warm boot message)
virtualized=$(/opt/cli/common/is_virtualized)
if [[ $(lspci | grep Xilinx | wc -l) = 2 ]] && [ "$virtualized" = "true" ]; then
    echo "Once you login again on the server, please type ${bold}sgutil validate coyote${normal} again."
    echo ""
fi

#this means that the user made a warm boot (virtualized) or the PCI hot plug script run (dedicated servers)
if [[ $(lspci | grep Xilinx | wc -l) = 1 ]]; then 

    #program coyote driver
    /opt/cli/program/vivado -d $APP_BUILD_DIR$DRIVER_NAME

    #get N_REGIONS
    line=$(grep -n "N_REGIONS" $DIR/configs/config_shell.hpp)
    #find equal (=)
    idx=$(sed 's/ /\n/g' <<< "$line" | sed -n "/=/=")
    #get index
    value_idx=$(($idx+1))
    #get data
    N_REGIONS=$(echo $line | awk -v i=$value_idx '{ print $i }' | sed 's/;//' )

    #fpga_chmod for N_REGIONS times
    for (( i = 0; i < $N_REGIONS; i++ ))
    do 
        sudo /opt/cli/program/fpga_chmod $i
    done

    #run 
    cd $APP_BUILD_DIR
    ./main
fi