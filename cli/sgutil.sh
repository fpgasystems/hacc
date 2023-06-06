#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
CLI_WORKDIR="/opt/cli"

#inputs
command=$1
arguments=$2

cli_help() {
  cli_name=${0##*/}
  echo "
${bold}$cli_name [commands] [arguments [flags]] [--help] [--version]${normal}

COMMANDS:
   build           - Creates binaries, bitstreams, and drivers for your accelerated applications.
   examine         - Status of the system and devices.
   get             - Devices and host information.
   new             - Creates a new project of your choice.
   program         - Download the acceleration program to a given FPGA/ACAP.
   reboot          - Reboots the server (warm boot).
   run             - Executes the accelerated application on a given device.
   set             - Devices and host configuration.
   validate        - Validates the basic HACC infrastructure functionality.

   -h, --help      - Help to use this application.
   -v, --version   - Reports CLI version.
"
  exit 1
}

cli_version() {
    version=$(cat $CLI_WORKDIR/VERSION)
    echo ""
    echo "Version              : $version"
    echo ""
    exit 1
}

command_run() {
    
    # we use an @ to separate between command_arguments_flags and the valid_flags
    read input <<< $@
    aux_1="${input%%@*}"
    aux_2="${input##$aux_1@}"

    read -a command_arguments_flags <<< "$aux_1"
    read -a valid_flags <<< "$aux_2"

    START=2
    if [ "${command_arguments_flags[$START]}" = "-h" ] || [ "${command_arguments_flags[$START]}" = "--help" ]; then
      ${command_arguments_flags[0]}_${command_arguments_flags[1]}_help # i.e., validate_iperf_help
    else
      flags=""
      j=0
      for (( i=$START; i<${#command_arguments_flags[@]}; i++ ))
      do
	      if [[ " ${valid_flags[*]} " =~ " ${command_arguments_flags[$i]} " ]]; then
	        flags+="${command_arguments_flags[$i]} "
	        i=$(($i+1))
	        flags+="${command_arguments_flags[$i]} "
	      else
          ${command_arguments_flags[0]}_${command_arguments_flags[1]}_help # i.e., validate_iperf_help
	      fi
      done

      /opt/cli/${command_arguments_flags[0]}/${command_arguments_flags[1]} $flags # Example: /opt/cli/validate/iperf -P 6

    fi
}

xilinx_build_check() {

    EMAIL=$(/opt/cli/common/get_email) #"jmoyapaya@ethz.ch"
    username=$USER
    url="${HOSTNAME}"
    hostname="${url%%.*}"

    #check for Xilinx device and build server
    if [[ $(lspci | grep Xilinx | wc -l) = 0 ]]; then
        if [ "$hostname" = "alveo-build-01" ]; then
            echo ""
            echo "Sorry, this command is not available on ${bold}$hostname!${normal}"
            echo ""
        else
            echo ""
            echo "The server needs special care to operate with XRT normally."
	          echo ""
	          echo "${bold}An email has been sent to the person in charge;${normal} we will let you know when XRT is ready to use again."
            echo ""
            #send email
            echo "Subject: $hostname requires special attention ($username)" | sendmail $EMAIL
        fi
        exit
    fi
}

# build ------------------------------------------------------------------------------------------------------------------------

build_help() {
    echo ""
    echo "${bold}sgutil build [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Creates binaries, bitstreams, and drivers for your accelerated applications."
    echo ""
    echo "ARGUMENTS:"
    echo "   coyote          - Generates Coyote's bitstreams and drivers." #Vitis .xo kernels and .xclbin binaries generation.
    echo "   hip             - Generates HIP binaries for your projects."
    echo "   mpi             - Generates MPI binaries for your projects."
    echo "   vitis           - Generates .xo kernels and .xclbin binaries for Vitis workflow." #Vitis .xo kernels and .xclbin binaries generation.
    #echo "   vivado (soon)   - Generates .bit bitstreams and .ko drivers for Vivado workflow." #Compiles a bitstream and a driver.
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

build_coyote_help() {
    echo ""
    echo "${bold}sgutil build coyote [flags] [--help]${normal}"
    echo ""
    echo "Generates Coyote's bitstreams and drivers."
    echo ""
    echo "FLAGS:"
    #echo "   -c, --config    - Coyote's configuration:"
    #echo "                         perf_hosts, perf_fpga, gbm_dtrees,"
    #echo "                         hyperloglog, perf_dram, perf_hbm,"
    #echo "                         perf_rdma_host, perf_rdma_card, perf_tcp,"
    #echo "                         rdma_regex, service_aes, service_reconfiguration."
    echo "   -n, --name      - FPGA's device name. See sgutil get device."
    echo "   -p, --project   - Specifies your Coyote project name."
    echo ""
    echo "   -h, --help      - Help to build Coyote."
    echo ""
    exit 1
}

build_hip_help() {
    echo ""
    echo "${bold}sgutil build hip [flags] [--help]${normal}"
    echo ""
    echo "Generates HIP binaries for your projects."
    echo ""
    echo "FLAGS:"
    echo "   -p, --project   - Specifies your HIP project name."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

build_mpi_help() {
    echo ""
    echo "${bold}sgutil build mpi [flags] [--help]${normal}"
    echo ""
    echo "Generates MPI binaries for your projects."
    echo ""
    echo "FLAGS:"
    #echo "   This command has no flags."
    echo "   -p, --project   - Specifies your MPI project name."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

build_vitis_help() {
    echo ""
    echo "${bold}sgutil build vitis [flags] [--help]${normal}"
    echo ""
    echo "Generates .xo kernels and .xclbin binaries for Vitis workflow."
    echo ""
    echo "FLAGS:"
    echo "   -p, --project   - Specifies your Vitis project name."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    #echo "   -t, --target    - Binary compilation target (sw_emu, hw_emu, hw)."
    echo ""
    echo "   -h, --help      - Help to build a binary."
    echo ""
    exit 1
}

build_vivado_help() {
    echo ""
    echo "${bold}sgutil build vivado [flags] [--help]${normal}"
    echo ""
    echo "Generates .bit bitstreams and .ko drivers for Vivado workflow."
    echo ""
    echo "FLAGS:"
    #echo "   -p, --project   - Specifies your Vivado project name."
    echo ""
    echo "   -h, --help      - Help to build a bitstream."
    echo ""
    exit 1
}

# examine ------------------------------------------------------------------------------------------------------------------------

examine_help() {
    echo ""
    echo "${bold}sgutil examine [--help]${normal}"
    echo ""
    echo "Status of the system and devices."
    echo ""
    echo "ARGUMENTS"
    echo "   This command has no arguments."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}


# get ----------------------------------------------------------------------------------------------------------------------------

get_help() {
    echo ""
    echo "${bold}sgutil get [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Devices and host information."
    echo ""
    echo "ARGUMENTS:"
    echo "   ifconfig        - Retreives host networking information."
    echo ""
    echo "   bdf             - Retreives FPGA/ACAP Bus Device Function."
    echo "   device          - Retreives FPGA/ACAP device names."
    echo "   network         - Retreives FPGA/ACAP networking information."
    echo "   serial          - Retreives FPGA/ACAP serial numbers."
    echo ""
    echo "   bus             - Retreives GPU PCI Bus ID."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_bdf_help() {
    echo ""
    echo "${bold}sgutil get bdf [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA/ACAP Bus Device Function."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA/ACAP Device Index (according to sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_bus_help() {
    echo ""
    echo "${bold}sgutil get bus [flags] [--help]${normal}"
    echo ""
    echo "Retreives GPU PCI Bus ID."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - GPU Device Index (according to sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_device_help() {
    echo ""
    echo "${bold}sgutil get device [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA/ACAP device names."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA/ACAP Device Index (according to sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_ifconfig_help() {
    echo ""
    echo "${bold}sgutil get ifconfig [--help]${normal}"
    echo ""
    echo "Retreives host networking information."
    echo ""
    echo "FLAGS:"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_network_help() {
    echo ""
    echo "${bold}sgutil get network [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA/ACAP networking information."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA/ACAP Device Index (according to sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_serial_help() {
    echo ""
    echo "${bold}sgutil get serial [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA/ACAP serial numbers."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA/ACAP Device Index (according to sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

# new ------------------------------------------------------------------------------------------------------------------------

new_help() {
    echo ""
    echo "${bold}sgutil new [arguments] [--help]${normal}"
    echo ""
    echo "Creates a new project of your choice."
    echo ""
    echo "ARGUMENTS:"
    echo "   coyote          - Creates a new project using Coyote Hello, world! template."
    echo "   hip             - Creates a new project using HIP Hello, world! template."
    echo "   mpi             - Creates a new project using MPI Hello, world! template."
    echo "   vitis           - Creates a new project using Vitis Hello, world! template." 
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

new_coyote_help() {
    echo ""
    echo "${bold}sgutil new coyote [--help]${normal}"
    echo ""
    echo "Creates a new project using Coyote Hello, world! template."
    echo ""
    echo "FLAGS"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

new_hpi_help() {
    echo ""
    echo "${bold}sgutil new hip [--help]${normal}"
    echo ""
    echo "Creates a new project using HIP Hello, world! template."
    echo ""
    echo "FLAGS"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

new_mpi_help() {
    echo ""
    echo "${bold}sgutil new mpi [--help]${normal}"
    echo ""
    echo "Creates a new project using MPI Hello, world! template."
    echo ""
    echo "FLAGS"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

new_vitis_help() {
    echo ""
    echo "${bold}sgutil new vitis [--help]${normal}"
    echo ""
    echo "Creates a new project using Vitis Hello, world! template."
    echo ""
    echo "FLAGS"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

# program ------------------------------------------------------------------------------------------------------------------------

program_help() {
    echo ""
    echo "${bold}sgutil program [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Download the acceleration program to a given FPGA/ACAP."
    echo ""
    echo "ARGUMENTS:"
    echo "   coyote          - Programs Coyote on a given device."
    echo "   reset           - Resets the given device."
    echo "   revert          - Returns the specified device to the Vitis workflow."
    echo "   vitis           - Programs a Vitis binary to a given device."
    echo "   vivado          - Programs a Vivado bitstream to a given device."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

program_coyote_help() {
    echo ""
    echo "${bold}sgutil program coyote [flags] [--help]${normal}"
    echo ""
    echo "Programs Coyote on a given device."
    echo ""
    echo "FLAGS:"
    echo "   -p, --project   - Specifies your Coyote project name." 
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}
#program_rescan_help() {
#    echo ""
#    echo "${bold}sgutil program rescan [flags] [--help]${normal}"
#    echo ""
#    echo "Runs the PCI hot-plug process."
#    echo ""
#    echo "FLAGS:"
#    echo "   -d, --device    - FPGA Device Index (see sgutil examine)."
#    echo ""
#    echo "   -h, --help      - Help to use this command."
#    echo ""
#    exit 1
#}

program_reset_help() {
    echo ""
    echo "${bold}sgutil program reset [flags] [--help]${normal}"
    echo ""
    echo "Resets the given device."
    echo ""
    echo "FLAGS:"
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

program_revert_help() {
    echo ""
    echo "${bold}sgutil program revert [flags] [--help]${normal}"
    echo ""
    echo "Returns the specified device to the Vitis workflow."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA Device Index (see sgutil examine)."
    echo ""
    echo "   -h, --help      - Help to revert a device."
    echo ""
    exit 1
}

program_vivado_help() {
    echo ""
    echo "${bold}sgutil program vivado [flags] [--help]${normal}"
    echo ""
    echo "Programs a Vivado bitstream to a given device."
    echo ""
    echo "FLAGS:"
    echo "   -b, --bitstream - Programs a .bit bitstream to the specified device." 
    echo "   -d, --driver    - Installs an FPGA driver on the server."
    echo "   -l, --ltx       - Specifies a .ltx debug probes file."
    echo "   -n, --name      - FPGA's device name. See sgutil get device."
    #echo "   -r, --revert    - Return the specified device to the Vitis workflow."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    echo ""
    echo "   -h, --help      - Help to program a bitstream."
    echo ""
    exit 1
}

program_vitis_help() {
    echo ""
    echo "${bold}sgutil program vitis [flags] [--help]${normal}"
    echo ""
    echo "Programs a Vitis binary to a given device."
    echo ""
    echo "FLAGS:"
    echo "   -d, --device    - FPGA Device Index (see sgutil examine)."
    echo "   -p, --project   - Specifies your Vitis project name."
    echo "   -r, --remote    - Local or remote deployment."
    echo ""
    echo "   -h, --help      - Help to program a binary."
    echo ""
    exit 1
}

# reboot -------------------------------------------------------------------------------------------------------

reboot_help() {
    echo ""
    echo "${bold}sgutil reboot [--help]${normal}"
    echo ""
    echo "Reboots the server (warm boot)."
    echo ""
    echo "ARGUMENTS:"
    echo "   This command has no arguments."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

# run ------------------------------------------------------------------------------------------------------------------------

run_help() {
    echo ""
    echo "${bold}sgutil run [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Executes your accelerated application."
    echo ""
    echo "ARGUMENTS:"
    echo "   mpi             - Runs your MPI application according to your setup."
    echo ""
    echo "   coyote          - Runs Coyote on a given FPGA/ACAP."
    echo "   vitis           - Runs a Vitis FPGA-binary on a given FPGA/ACAP."
    echo ""
    echo "   hip             - Runs your HIP application on a given GPU."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

run_coyote_help() {
    echo ""
    echo "${bold}sgutil run coyote [flags] [--help]${normal}"
    echo ""
    echo "Runs Coyote on a given FPGA/ACAP."
    echo ""
    echo "FLAGS:"
    echo "   -p, --project   - Specifies your Coyote project name."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    #echo "   -t, --target    - Binary compilation target (sw_emu, hw_emu, hw)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

run_hip_help() {
    echo ""
    echo "${bold}sgutil run hip [flags] [--help]${normal}"
    echo ""
    echo "Runs your HIP application on a given GPU."
    echo ""
    echo "FLAGS"
    echo "   -p, --project   - Specifies your HIP project name."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

run_mpi_help() {
    echo ""
    echo "${bold}sgutil run mpi [flags] [--help]${normal}"
    echo ""
    echo "Runs your MPI application according to your setup."
    echo ""
    echo "FLAGS"
    #echo "   This command has no flags."
    echo "   -p, --project   - Specifies your MPI project name."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

run_vitis_help() {
    echo ""
    echo "${bold}sgutil run vitis [flags] [--help]${normal}"
    echo ""
    echo "Runs a Vitis FPGA-binary on a given FPGA/ACAP."
    echo ""
    echo "FLAGS:"
    echo "   -p, --project   - Specifies your Vitis project name."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    #echo "   -t, --target    - Binary compilation target (sw_emu, hw_emu, hw)."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

# set ------------------------------------------------------------------------------------------------------------------------

set_help() {
    echo ""
    echo "${bold}sgutil set [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Changes the configuration of your server or given device."
    echo ""
    echo "ARGUMENTS:"
    echo "   keys            - Creates your RSA key pairs and adds to authorized_keys and known_hosts."
    echo "   write           - Assigns writing permissions on a given device."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

set_keys_help() {
    echo ""
    echo "${bold}sgutil set keys [--help]${normal}"
    echo ""
    echo "Creates your RSA key pairs and adds to authorized_keys and known_hosts."
    echo ""
    echo "FLAGS:"
    echo "   This command has no flags."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

set_write_help() {
      echo ""
      echo "${bold}sgutil set write [flags] [--help]${normal}"
      echo ""
      echo "Assigns writing permissions to a given device."
      echo ""
      echo "FLAGS:"
      echo "   -i, --index     - PCI device index. See sgutil get devices."
      echo ""
      echo "   -h, --help      - Help to use this command."
      echo ""
      exit 1
}

# validate -----------------------------------------------------------------------------------------------------------------------
validate_help() {
    echo ""
    echo "${bold}sgutil validate [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Validates the basic HACC infrastructure functionality."
    echo ""
    echo "ARGUMENTS:"
    echo "   iperf           - Measures HACC network performance."
    echo "   mpi             - Validates MPI."
    echo ""
    echo "   coyote          - Validates Coyote on the selected FPGA/ACAP."
    echo "   vitis           - Validates Vitis workflow on the selected FPGA/ACAP." 
    echo ""
    echo "   hip             - Validates HIP on the selected GPU." 
    echo "" 
    echo "   -h, --help      - Help to use this command."
    #echo "   openmpi         - Validates openmpi (to be removed)."
    echo ""
    exit 1
}

validate_coyote_help() {
      echo ""
      echo "${bold}sgutil validate coyote [flags] [--help]${normal}"
      echo ""
      echo "Validates Coyote on the selected FPGA/ACAP."
      echo ""
      echo "FLAGS:"
      echo "   -n, --name      - FPGA's device name. See sgutil get device."
      echo ""
      echo "   -h, --help      - Help to use Coyote validation."
      echo ""
      exit 1
}

validate_hip_help() {
      echo ""
      echo "${bold}sgutil validate hip [flags] [--help]${normal}"
      echo ""
      echo "Validates HIP on the selected GPU."
      echo ""
      echo "FLAGS:"
      echo "   -d, --device    - GPU Device Index (see sgutil examine)."
      echo ""
      echo "   -h, --help      - Help to use HIP validation."
      echo ""
      exit 1
}

validate_iperf_help() {
      echo ""
      echo "${bold}sgutil validate iperf [flags] [--help]${normal}"
      echo ""
      echo "Measures HACC network performance."
      echo ""
      echo "FLAGS:"
      echo "   -b, --bandwidth - Bandwidth to send at in bits/sec or packets per second."
      #echo "   -d, --default   - Runs an iperf test using -P 4 and"
      #echo "                     equals to run sgutil validate iperf without flags."
      echo "   -p, --parallel  - Number of parallel client threads to run."
      echo "   -t, --time      - Time in seconds to transmit for."
      echo "   -u, --udp       - Use UDP rather than TCP."
      echo ""
      echo "   -h, --help      - Help to use iperf validation."
      echo ""
      exit 1
}

validate_mpi_help() {
      echo ""
      echo "${bold}sgutil validate mpi [flags] [--help]${normal}"
      echo ""
      echo "Validates MPI."
      echo ""
      echo "FLAGS:"
      #echo "   -d, --default   - Runs an mpi test using two --processes per host and"
      #echo "                     equals to run sgutil validate mpi without flags."
      echo "   -p, --processes - Specify the number of processes to use."
      echo ""
      echo "   -h, --help      - Help to use MPI validation."
      echo ""
      exit 1
}

validate_vitis_help() {
      echo ""
      echo "${bold}sgutil validate vitis [flags] [--help]${normal}"
      echo ""
      echo "Validates Vitis workflow on the selected FPGA/ACAP."
      echo ""
      echo "FLAGS:"
      echo "   -d, --device    - FPGA Device Index (see sgutil examine)."
      echo ""
      echo "   -h, --help      - Help to use Vitis validation."
      echo ""
      exit 1
}

# read all input parameters (@)
read command_arguments_flags <<< $@ #command$arguments

# ensure -h or --help are going at the beginning
#-h
if [[ $(echo "$command_arguments_flags" | grep "\-h\b" | wc -l) = 1 ]]; then
  #echo "first: $command_arguments_flags"
  #remove -h
  command_arguments_flags=${command_arguments_flags/-h/""}
  #echo "second: $command_arguments_flags"
  #remove command and arguments
  command_arguments_flags=${command_arguments_flags/$command" "/""}
  #echo "third: $command_arguments_flags"
  command_arguments_flags=${command_arguments_flags/$arguments" "/""}
  #echo "fourth: $command_arguments_flags"
  #add it at the beginning
  command_arguments_flags=$command" "$arguments" -h "$command_arguments_flags
  #echo "fifth: $command_arguments_flags"
fi
#--help
if [[ $(echo "$command_arguments_flags" | grep "\-\-help\b" | wc -l) = 1 ]]; then
  #echo "first: $command_arguments_flags"
  #remove --help
  command_arguments_flags=${command_arguments_flags/--help/""}
  #echo "second: $command_arguments_flags"
  #remove command and arguments
  command_arguments_flags=${command_arguments_flags/$command" "/""}
  #echo "third: $command_arguments_flags"
  command_arguments_flags=${command_arguments_flags/$arguments" "/""}
  #echo "fourth: $command_arguments_flags"
  #add it at the beginning
  command_arguments_flags=$command" "$arguments" -h "$command_arguments_flags
  #echo "fifth: $command_arguments_flags"
fi

# sgutil
case "$command" in
  -h|--help)
    cli_help
    ;;
  -v|--version)
    cli_version
    ;;
  build)
    case "$arguments" in
      -h|--help)
        build_help
        ;;
      coyote) 
        valid_flags="-n --name -p --project -h --help" #-c --config 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      hip) 
        valid_flags="-p --project -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      mpi) 
        #if [ "$#" -ne 2 ]; then
        #  build_mpi_help
        #  exit 1
        #fi
        #/opt/cli/build/mpi
        valid_flags="-p --project -h --help" 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      vitis) 
        valid_flags="-p --project -s --serial -h --help" #-t --target
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        build_help
      ;;  
    esac
    ;;
  examine)
    #xilinx_build_check
    case "$arguments" in
      -h|--help)
        examine_help
        ;;
      *)
        if [ "$#" -ne 1 ]; then
          examine_help
          exit 1
        fi
        /opt/cli/examine
        ;;
    esac
    ;;
  get)
    case "$arguments" in
      -h|--help)
        get_help
        ;;
      bdf)
        valid_flags="-h --help -d --device"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      bus)
        valid_flags="-h --help -d --device"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      device)
        #xilinx_build_check
        valid_flags="-h --help -d --device"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      #ip)
      #  valid_flags="-h --help -d --device"
      #  command_run $command_arguments_flags"@"$valid_flags
      #  ;;
      #mac)
      #  valid_flags="-h --help -w --word"
      #  command_run $command_arguments_flags"@"$valid_flags
      #  ;;
      ifconfig)
        valid_flags="-h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      network)
        valid_flags="-h --help -d --device"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      serial)
        #xilinx_build_check
        valid_flags="-h --help -d --device"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        get_help
      ;;
    esac
    ;;
  new)

    #if [ "$#" -ne 2 ]; then
    #  new_help
    #  exit 1
    #fi

    case "$arguments" in
      -h|--help)
        new_help
        ;;
      coyote)
        if [ "$#" -ne 2 ]; then
          new_coyote_help
          exit 1
        fi
        /opt/cli/new/coyote
        ;;
      hip)
        if [ "$#" -ne 2 ]; then
          new_hpi_help
          exit 1
        fi
        /opt/cli/new/hip
        ;;
      mpi)
        if [ "$#" -ne 2 ]; then
          new_mpi_help
          exit 1
        fi
        /opt/cli/new/mpi
        ;;
      vitis)
        if [ "$#" -ne 2 ]; then
          new_vitis_help
          exit 1
        fi
        /opt/cli/new/vitis
        ;;
      #vivado)
      #  /opt/cli/new/vivado
      #  ;;
      *)
        new_help
      ;;
    esac
    ;;
  program)
    xilinx_build_check
    case "$arguments" in
      -h|--help)
        program_help
        ;;
      coyote)
        valid_flags="-p --project -s --serial -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      #reboot)
      #  if [ "$#" -ne 2 ]; then
      #    program_reboot_help
      #    exit 1
      #  fi
      #  /opt/cli/program/reboot
      #  ;;
      #rescan) # flags can be empty if we have only one FPGA
      #  valid_flags="-d --device -h --help"
      #  command_run $command_arguments_flags"@"$valid_flags
      #  ;;
      reset) 
        valid_flags="-s --serial -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      revert) # flags can be empty if we have only one FPGA
        valid_flags="-d --device -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      vivado) # flags cannot be empty (i.e. at least -b is required)
        valid_flags="-d --driver -b --bitstream -l --ltx -n --name -s --serial -h --help" #-r --revert
        command_run $command_arguments_flags"@"$valid_flags

        # check if flags are empty (first is at position 2)
        #read -a aux_flags <<< "$command_arguments_flags"
        #if [ "${aux_flags[2]}" = "" ]; then
        #  program_vivado_help
        #else
        #  command_run $command_arguments_flags"@"$valid_flags
        #fi
        ;;
      vitis)
        valid_flags="-d --device -p --project -r --remote -h --help" # -b --binary -n --name -t --target -u --user
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        program_help
      ;;
    esac
    ;;
  reboot)
    case "$arguments" in
      -h|--help)
        reboot_help
        ;;
      *)
        if [ "$#" -ne 1 ]; then
          reboot_help
          exit 1
        fi
        /opt/cli/reboot
        ;;
    esac
    ;;
  run)
    xilinx_build_check
    case "$arguments" in
      -h|--help)
        run_help
        ;;
      coyote) 
        valid_flags="-p --project -s --serial -h --help" # -b --binary -n --name -t --target 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      hip) 
        valid_flags="-p --project -h --help" 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      mpi) 
        valid_flags="-p --project -h --help" 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      vitis) 
        valid_flags="-p --project -s --serial -h --help" # -b --binary -n --name -t --target 
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        run_help
      ;;  
    esac
    ;;
  set)
    xilinx_build_check
    case "$arguments" in
      -h|--help)
        set_help
        ;;
      keys)
        if [ "$#" -ne 2 ]; then
          set_keys_help
          exit 1
        fi
        eval "/opt/cli/set/keys"
        ;;
      write) 
        valid_flags="-i --index -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        set_help
      ;;  
    esac
    ;;
  validate)
    xilinx_build_check
    case "$arguments" in
      coyote)
        valid_flags="-n --name -h --help"
        #if [ "$#" -ne 2 ]; then
        #  validate_coyote_help
        #  exit 1
        #fi
        #/opt/cli/validate/coyote
        command_run $command_arguments_flags"@"$valid_flags
      ;;
      hip)
        valid_flags="-d --device -h --help"
        command_run $command_arguments_flags"@"$valid_flags
      ;;
      iperf)
        #valid flags
        valid_flags="-b --bandwidth -h --help -p --parallel -t --time -u --udp"
        
        # ensure -u or --udp are going at the end
        #-u
        if [[ $(echo "$command_arguments_flags" | grep "\-u\b" | wc -l) = 1 ]]; then
          #remove -u
          command_arguments_flags=${command_arguments_flags/-u/""}
          #add it at the end
          command_arguments_flags=$command_arguments_flags" -u"
        fi
        #--udp
        if [[ $(echo "$command_arguments_flags" | grep "\-\-udp\b" | wc -l) = 1 ]]; then
          #remove --udp
          command_arguments_flags=${command_arguments_flags/--udp/""}
          #add it at the end
          command_arguments_flags=$command_arguments_flags" -u" # this is done on purpose (see iperf.sh)
        fi
        command_run $command_arguments_flags"@"$valid_flags
      ;;
      mpi)
        valid_flags="-h --help -p --processes"
        command_run $command_arguments_flags"@"$valid_flags
      ;;
      vitis)
        valid_flags="-d --device -h --help"
        command_run $command_arguments_flags"@"$valid_flags
      ;;
      #openmpi) 
      #  eval "/opt/cli/validate/openmpi"
      #;;
      *)
        validate_help
      ;;
    esac
    ;;
  *)
    cli_help
    ;;
esac