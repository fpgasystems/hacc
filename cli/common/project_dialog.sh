#!/bin/bash

username=$1
workflow=$2

# Declare global variables
declare -g project_found="0"
declare -g project_name=""

# no flags: start dialog
cd /home/$username/my_projects/$workflow/
projects=( *"/" )

# delete "common" from projects
j=0
for i in "${projects[@]}"
do
    if [[ $i =~ "common/" ]]; then
        echo "" >&/dev/null
    else
        aux[j]=$i
        j=$(($j + 1))
    fi
done

#echo ""
#echo "${bold}Please, choose your project:${normal}"
#echo ""
PS3=""

# Capture user selection into the project_name variable
select project_name in "${aux[@]}"; do
    if [[ -z $project_name ]]; then
        echo "" >&/dev/null
    else
        project_found="1"
        project_name=${project_name::-1} # remove the last character, i.e. "/"
        break
    fi
done

# Return the values of project_found and project_name
echo "$project_found"
echo "$project_name"