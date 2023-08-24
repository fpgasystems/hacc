#!/bin/bash

DIR=$1 
EXTENSION=$2 

# Declare global variables
declare -g file_list=""

# Use find command to locate all .cpp files in the specified directory
# and loop through the results
while IFS= read -r -d $'\0' file; do
    # Append the filename to the file_list string
    file_list="${file_list}${file} "
done < <(find "$DIR" -type f -name "*$EXTENSION" -print0)

# Remove trailing space using parameter expansion
file_list="${file_list%" "}"

#return list
echo "$file_list"