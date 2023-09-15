#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
#PATH="$(dirname "$0")" #"$(dirname "$(dirname "$0")")"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

#remove all md
rm *.md

#echo $DIR

#echo ""
#echo "Copying /docs:"
#copy all md
cp ../docs/*.md $DIR


#grep -v '#([^)]*)' ./vocabulary.md > ./new_vocabulary.md
#sed -i 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' vocabulary.md
sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' vocabulary.md

for file in *.md; do
  # Check if the file exists and is a regular file
  if [[ -f "$file" ]]; then
    #removing markdown links e.g. [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' "$file"
    #echo "Processed $file"
  fi
done