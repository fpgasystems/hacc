#!/bin/bash

_sgutil_completions()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "build get new program run validate --help --version" -- ${cur})) # -h -v
            ;;
        2)
            case ${prev} in
                build)
                    COMPREPLY=($(compgen -W "coyote vitis --help" -- ${cur})) # -h
                    ;;
                get)
                    COMPREPLY=($(compgen -W "device ip mac serial --help" -- ${cur})) # -h
                    ;;
                new)
                    COMPREPLY=($(compgen -W "coyote vitis vivado --help" -- ${cur}))
                    ;;
                program)
                    COMPREPLY=($(compgen -W "coyote rescan revert vitis vivado --help" -- ${cur})) # -h
                    ;;
                run)
                    COMPREPLY=($(compgen -W "coyote vitis --help" -- ${cur})) # -h
                    ;;
                validate)
                    COMPREPLY=($(compgen -W "iperf mpi --help" -- ${cur})) # -h
                    ;;
            esac
            ;;
        3)
            case ${prev} in
                coyote) # build
                    COMPREPLY=($(compgen -W "--name --project --help" -- ${cur})) #--config 
                    ;;
                vitis) 
                    COMPREPLY=($(compgen -W "--project --serial --help" -- ${cur})) # -w -h --target 
                    ;;
                device) # get
                    COMPREPLY=($(compgen -W "--word --help" -- ${cur})) # -w -h
                    ;;
                ip) 
                    COMPREPLY=($(compgen -W "--word --help" -- ${cur})) # -w -h 
                    ;;
                mac) 
                    COMPREPLY=($(compgen -W "--word --help" -- ${cur})) # -w  -h
                    ;;
                serial) 
                    COMPREPLY=($(compgen -W "--word --help" -- ${cur})) # -w  -h
                    ;;
                coyote) # program
                    COMPREPLY=($(compgen -W "--project --serial --help" -- ${cur})) # -n  -s  -h
                    ;;
                revert)
                    COMPREPLY=($(compgen -W "--name --serial --help" -- ${cur})) # -n  -s  -h
                    ;;
                vivado) 
                    COMPREPLY=($(compgen -W "--bitstream --driver --ltx --name --serial --help" -- ${cur})) # -b -d -l -n -s -h
                    ;;
                vitis) 
                    COMPREPLY=($(compgen -W "--project --serial  --help" -- ${cur})) # -b -n -s -t -h --binary --name --target --user
                    ;;
                coyote) # run 
                    COMPREPLY=($(compgen -W "--project --serial --help" -- ${cur})) 
                    ;;
                vitis)
                    COMPREPLY=($(compgen -W "--project --serial --help" -- ${cur})) # -b -n -s -t -h --binary --name --target 
                    ;;
                iperf) # validate
                    COMPREPLY=($(compgen -W " --bandwidth --parallel --time --udp --help" -- ${cur})) # -b -P -t -u -h
                    ;;
                mpi) 
                    COMPREPLY=($(compgen -W "--processes --help" -- ${cur})) # -n -h
                    ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac

}

complete -F _sgutil_completions sgutil