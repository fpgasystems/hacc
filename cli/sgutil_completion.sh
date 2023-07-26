#!/bin/bash

_sgutil_completions()
{
    local cur prev

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "build enable examine get new program reboot run set validate --help --version" -- ${cur})) # -h -v
            ;;
        2)
            case ${COMP_WORDS[COMP_CWORD-1]} in
                build)
                    COMPREPLY=($(compgen -W "coyote hip mpi vitis --help" -- ${cur})) # -h
                    ;;
                enable)
                    COMPREPLY=($(compgen -W "vitis vivado xrt --help" -- ${cur}))
                    ;;
                examine)
                    COMPREPLY=($(compgen -W "--help" -- ${cur}))
                    ;;
                get)
                    COMPREPLY=($(compgen -W "bdf bus name ifconfig network platform serial workflow --help" -- ${cur})) # -h ip mac
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
            case ${COMP_WORDS[COMP_CWORD-2]} in
                build)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
                        coyote) # build
                            COMPREPLY=($(compgen -W "--platform --project --help" -- ${cur})) #--config 
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
                    esac
                    ;;
                enable) 
                    case ${COMP_WORDS[COMP_CWORD-1]} in
                        vitis) # enable
                            COMPREPLY=($(compgen -W "--version --help" -- ${cur})) # -w -h
                            ;;
                        vivado) 
                            COMPREPLY=($(compgen -W "--version --help" -- ${cur})) # -w -h
                            ;;
                        xrt) 
                            COMPREPLY=($(compgen -W "--version --help" -- ${cur})) # -w -h
                            ;;
                    esac
                    ;;
                get)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
                        bdf) # get
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                            ;;
                        bus)
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                            ;;
                        name)
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w -h
                            ;;
                        ifconfig) 
                            COMPREPLY=($(compgen -W " --help" -- ${cur}))
                            ;;
                        network) 
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur}))
                            ;;
                        platform) 
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w  -h
                            ;;
                        serial) 
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w  -h
                            ;;
                        workflow) 
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur})) # -w  -h
                            ;;
                    esac
                    ;;
                program)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
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
                            COMPREPLY=($(compgen -W "--bitstream --device --driver --help" -- ${cur})) # -b -d -l -n -s -h
                            ;;
                    esac
                    ;;
                run)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
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
                    esac
                    ;;
                set)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
                        keys) # set 
                            COMPREPLY=($(compgen -W "--help" -- ${cur})) 
                            ;;
                        write)
                            COMPREPLY=($(compgen -W "--index --help" -- ${cur})) 
                            ;;
                    esac
                    ;;
                validate)
                    case ${COMP_WORDS[COMP_CWORD-1]} in
                        coyote) # validate
                            COMPREPLY=($(compgen -W "--device --help" -- ${cur}))
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
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -F _sgutil_completions sgutil