#!/bin/bash

_sgutil_completions()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "build examine get new program run set validate --help --version" -- ${cur})) # -h -v
            ;;
        2)
            case ${prev} in
                build)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # -h
                    ;;
                examine)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                get)
                    COMPREPLY=($(compgen -W "device ip mac serial --help" -- ${cur})) # -h
                    ;;
                new)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # vivado
                    ;;
                program)
                    COMPREPLY=($(compgen -W "coyote reboot rescan reset revert vitis vivado --help" -- ${cur})) # -h
                    ;;
                run)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # -h
                    ;;
                set)
                    COMPREPLY=($(compgen -W "keys write --help" -- ${cur})) # -h
                    ;;
                validate)
                    COMPREPLY=($(compgen -W "coyote hip iperf mpi --help" -- ${cur})) # -h
                    ;;
            esac
            ;;
        3)
            case ${prev} in
                coyote) # build
                    COMPREPLY=($(compgen -W "--name --project --help" -- ${cur})) #--config 
                    ;;
                mpi)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
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
                reboot)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                revert)
                    COMPREPLY=($(compgen -W "--name --serial --help" -- ${cur})) # -n  -s  -h
                    ;;
                reset)
                    COMPREPLY=($(compgen -W "--serial --help" -- ${cur}))
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
                mpi)
                    COMPREPLY=($(compgen -W "--project --help" -- ${cur}))
                    ;;
                vitis)
                    COMPREPLY=($(compgen -W "--project --serial --help" -- ${cur})) # -b -n -s -t -h --binary --name --target 
                    ;;
                keys) # set 
                    COMPREPLY=($(compgen -W "--help" -- ${cur})) 
                    ;;
                write)
                    COMPREPLY=($(compgen -W "--index --help" -- ${cur})) 
                    ;;
                coyote) # validate
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                iperf)
                    COMPREPLY=($(compgen -W "--bandwidth --parallel --time --udp --help" -- ${cur})) # -b -P -t -u -h
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