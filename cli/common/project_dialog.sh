#!/bin/bash

#username=$1
#workflow=$2

MY_PROJECTS_WORKFLOW_PATH=$1

# Declare global variables
declare -g project_found="0"
declare -g project_name=""
declare -g multiple_projects="0"

#get projects
cd $MY_PROJECTS_WORKFLOW_PATH #/home/$username/my_projects/$workflow/
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

# Check if there is only one directory
if [ ${#aux[@]} -eq 1 ]; then
    project_found="1"
    project_name=${aux[0]}
    project_name=${project_name::-1} # remove the last character, i.e. "/"
else
    multiple_projects="1"
    PS3=""
    select project_name in "${aux[@]}"; do
        if [[ -z $project_name ]]; then
            echo "" >&/dev/null
        else
            project_found="1"
            project_name=${project_name::-1} # remove the last character, i.e. "/"
            break
        fi
    done
fi

# Return the values of project_found and project_name
echo "$project_found"
echo "$project_name"
echo "$multiple_projects"