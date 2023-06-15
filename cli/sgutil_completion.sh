#!/bin/bash

_sgutil_completions()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "build examine get new program reboot run set validate --help --version" -- ${cur})) # -h -v
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
                    COMPREPLY=($(compgen -W "bdf bus name ifconfig network serial --help" -- ${cur})) # -h ip mac
                    ;;
                new)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # vivado
                    ;;
                program)
                    COMPREPLY=($(compgen -W "coyote reset revert vitis vivado --help" -- ${cur})) # -h rescan
                    ;;
                reboot)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                run)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # -h
                    ;;
                set)
                    COMPREPLY=($(compgen -W "keys write --help" -- ${cur})) # -h
                    ;;
                validate)
                    COMPREPLY=($(compgen -W "coyote hip iperf mpi vitis --help" -- ${cur})) # -h
                    ;;
            esac
            ;;
        3)
            case ${prev} in
                coyote) # build
                    COMPREPLY=($(compgen -W "--name --project --help" -- ${cur})) #--config 
                    ;;
                hip)
                    COMPREPLY=($(compgen -W "--project --help" -- ${cur}))
                    ;;
                mpi)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                vitis) 
                    COMPREPLY=($(compgen -W "--platform --project --target --help" -- ${cur}))
                    ;;
                bdf) # get
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                    ;;
                bus)
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                    ;;
                name)
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                    ;;
                #ip) 
                #    COMPREPLY=($(compgen -W "--device --help" -- ${cur}))
                #    ;;
                #mac) 
                #    COMPREPLY=($(compgen -W "--word --help" -- ${cur})) # -w  -h
                #    ;;
                ifconfig) 
                    COMPREPLY=($(compgen -W " --help" -- ${cur}))
                    ;;
                network) 
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur}))
                    ;;
                serial) 
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w  -h
                    ;;
                coyote) # program
                    COMPREPLY=($(compgen -W "--device --project --remote --help" -- ${cur})) # -n  -s  -h
                    ;;
                reset)
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur}))
                    ;;
                revert)
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -n  -s  -h
                    ;;
                vitis) 
                    COMPREPLY=($(compgen -W "--device --project --remote --help" -- ${cur}))
                    ;;
                vivado) 
                    COMPREPLY=($(compgen -W "--bitstream --device --driver --ltx --name --serial --help" -- ${cur})) # -b -d -l -n -s -h
                    ;;
                coyote) # run 
                    COMPREPLY=($(compgen -W "--device --project --help" -- ${cur})) 
                    ;;
                hip)
                    COMPREPLY=($(compgen -W "--project --help" -- ${cur}))
                    ;;
                mpi)
                    COMPREPLY=($(compgen -W "--project --help" -- ${cur}))
                    ;;
                vitis)
                    COMPREPLY=($(compgen -W " --device --project --target --help" -- ${cur}))
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
                hip)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                iperf)
                    COMPREPLY=($(compgen -W "--bandwidth --parallel --time --udp --help" -- ${cur})) # -b -P -t -u -h
                    ;;
                mpi) 
                    COMPREPLY=($(compgen -W "--processes --help" -- ${cur})) # -n -h
                    ;;
                vitis) 
                    COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -n -h
                    ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac

}

complete -F _sgutil_completions sgutil