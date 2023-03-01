#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# constants
CLI_WORKDIR="/opt/cli"

# inputs
command=$1
arguments=$2

cli_help() {
  cli_name=${0##*/}
  echo "
${bold}$cli_name [commands] [arguments [flags]] [--help] [--version]${normal}

COMMANDS:
   build           - Creates binaries, bitstreams, and drivers for your accelerated applications.
   get             - Retreives information from the server/s.
   new             - Creates a new project of your choice.
   program         - Downloads the accelerated application or driver to a given device.
   run             - Executes the accelerated application on a given device.
   set             - Changes the configuration on a given device.
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


# build ------------------------------------------------------------------------------------------------------------------------

build_help() {
    echo ""
    echo "${bold}sgutil build [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Creates binaries, bitstreams, and drivers for your accelerated applications."
    echo ""
    echo "ARGUMENTS:"
    echo "   coyote          - Generates Coyote's bitstreams and drivers." #Vitis .xo kernels and .xclbin binaries generation.
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
    echo "   -h, --help      - Help to build Coyote."
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

# get ----------------------------------------------------------------------------------------------------------------------------

get_help() { #it makes sense to group the flags here as they are the same for all the arguments
    echo ""
    echo "${bold}sgutil get [arguments [flags]] [--help]${normal}"
    echo ""
    echo "Retreives information from the server/s."
    echo ""
    echo "ARGUMENTS:"
    echo "   device          - Retreives FPGA device name from the server/s."
    echo "   ip              - Retreives IP information from the server/s."
    echo "   mac             - Retreives L2 information from the server/s."
    echo "   serial          - Retreives FPGA serial number from the server/s."
    echo ""
    echo "   -h, --help      - Help to use this command."
    #echo ""
    #echo "FLAGS:"
    #echo "   -l, --local     - Retreives information from the local server."
    #echo "   -w, --word      - Filters information according to regexp expression."
    #echo ""
    #echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_device_help() {
    echo ""
    echo "${bold}sgutil get device [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA device name from the server/s."
    echo ""
    echo "FLAGS:"
    echo "   -w, --word      - Filters FPGA device name according to regexp expression."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_ip_help() {
    echo ""
    echo "${bold}sgutil get ip [flags] [--help]${normal}"
    echo ""
    echo "Retreives IP information from the server/s."
    echo ""
    echo "FLAGS:"
    echo "   -w, --word      - Filters IP information according to regexp expression."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_mac_help() {
    echo ""
    echo "${bold}sgutil get mac [flags] [--help]${normal}"
    echo ""
    echo "Retreives L2 information from the server/s."
    echo ""
    echo "FLAGS:"
    echo "   -w, --word      - Filters L2 information according to regexp expression."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

get_serial_help() {
    echo ""
    echo "${bold}sgutil get serial [flags] [--help]${normal}"
    echo ""
    echo "Retreives FPGA serial number from the server/s."
    echo ""
    echo "FLAGS:"
    echo "   -w, --word      - Filters FPGA serial number according to regexp expression."
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
    echo "   mpi             - Creates a new project using MPI Hello, world! template."
    echo "   vitis           - Creates a new project using Vitis Hello, world! template."
    #echo "   vivado          - Creates a new project using Vivado Hello, world! template."
    #echo "   bin             - Programs a Vitis FPGA-bitstream to a given device."
    #echo "   bit             - Programs a Vivado FPGA-bitstream to a given device."
    #echo "   drv             - Installs an FPGA driver on the server." 
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
    echo "Downloads the accelerated application or driver to a given device."
    echo ""
    echo "ARGUMENTS:"
    echo "   coyote          - Programs Coyote on a given device."
    echo "   rescan          - Runs the PCI hot-plug process."
    echo "   reset           - Resets the given device."
    echo "   revert          - Returns the specified device to the Vitis workflow."
    echo "   vitis           - Programs a Vitis FPGA-binary to a given device."
    echo "   vivado          - Programs a Vivado FPGA-bitstream to a given device."
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

program_rescan_help() {
    echo ""
    echo "${bold}sgutil program rescan [flags] [--help]${normal}"
    echo ""
    echo "Runs the PCI hot-plug process."
    echo ""
    echo "FLAGS:"
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

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
    #echo "   -b, --bitstream - Programs a .bit bitstream to the specified device." 
    #echo "   -d, --driver    - Installs an FPGA driver on the server."
    echo "   -n, --name      - FPGA's device name. See sgutil get device."
    #echo "   -r, --revert    - Return the specified device to the Vitis workflow."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    echo ""
    echo "   -h, --help      - Help to revert a device."
    echo ""
    exit 1
}

program_vivado_help() {
    echo ""
    echo "${bold}sgutil program vivado [flags] [--help]${normal}"
    echo ""
    echo "Programs a Vivado FPGA-bitstream to a given device."
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
    echo "Programs a Vitis FPGA-binary to a given device."
    echo ""
    echo "FLAGS:"
    #echo "   -b, --binary    - Programs an .xclbin binary to the specified device." 
    #echo "   -n, --name      - FPGA's device name. See sgutil get device."
    echo "   -p, --project   - Specifies your Vitis project name."
    echo "   -s, --serial    - FPGA's serial number. See sgutil get serial."
    #echo "   -t, --target    - Binary compilation target (sw_emu, hw_emu, hw). REMOVE!!!"
    #echo "   -u, --user      - The name (and path) of the xclbin to be loaded."
    echo ""
    echo "   -h, --help      - Help to program a binary."
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
    echo "   coyote          - Runs Coyote on a given device."
    echo "   vitis           - Runs a Vitis FPGA-binary on a given device."
    echo "   mpi             - Runs your MPI application according to your setup."
    #echo "   vivado (soon)   - Runs a Vivado FPGA-bitstream on a given device."
    #echo "   bin             - Programs a Vitis FPGA-bitstream to a given device."
    #echo "   bit             - Programs a Vivado FPGA-bitstream to a given device."
    #echo "   drv             - Installs an FPGA driver on the server." 
    echo ""
    echo "   -h, --help      - Help to use this command."
    echo ""
    exit 1
}

run_coyote_help() {
    echo ""
    echo "${bold}sgutil run coyote [flags] [--help]${normal}"
    echo ""
    echo "Runs Coyote on a given device."
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
    echo "Runs a Vitis FPGA-binary on a given device."
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
    echo "Changes the configuration on a given device."
    echo ""
    echo "ARGUMENTS:"
    echo "   write           - Assigns writing permissions on a given device."
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
    echo "   coyote          - Validates Coyote for a configuration of your choice."
    echo "   iperf           - Measures HACC network performance."
    echo "   mpi             - Validates MPI." 
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
      echo "Validates Coyote for a configuration of your choice."
      echo ""
      echo "FLAGS:"
      echo "   -n, --name      - FPGA's device name. See sgutil get device."
      echo ""
      echo "   -h, --help      - Help to use Coyote validation."
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
  get)
    case "$arguments" in
      -h|--help)
        get_help
        ;;
      device)
        valid_flags="-h --help -w --word"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      ip)
        valid_flags="-h --help -w --word"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      mac)
        valid_flags="-h --help -w --word"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      serial)
        valid_flags="-h --help -w --word"
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
    case "$arguments" in
      -h|--help)
        program_help
        ;;
      coyote)
        valid_flags="-p --project -s --serial -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      rescan) # flags can be empty if we have only one FPGA
        valid_flags="-s --serial -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      reset) 
        valid_flags="-s --serial -h --help"
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      revert) # flags can be empty if we have only one FPGA
        valid_flags="-n --name -s --serial -h --help"
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
        valid_flags="-p --project -s --serial -h --help" # -b --binary -n --name -t --target -u --user
        command_run $command_arguments_flags"@"$valid_flags
        ;;
      *)
        program_help
      ;;
    esac
    ;;
  run)
    case "$arguments" in
      -h|--help)
        run_help
        ;;
      coyote) 
        valid_flags="-p --project -s --serial -h --help" # -b --binary -n --name -t --target 
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
    case "$arguments" in
      -h|--help)
        set_help
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