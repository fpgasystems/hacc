#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#change to directory
cd $DIR

#remove overleaf directory
if [ -d "$DIR/overleaf" ]; then
    rm -r "$DIR/overleaf"
fi

#create overleaf directory
mkdir $DIR/overleaf

#export to overleaf
for file in *.md; do  
  if [[ -f "$file" ]]; then
    # Create a new file with modified name
    new_file="${file%.md}-tex.md"
    cp "$file" "$new_file"
    #remove markdown links, e.g. [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' "$new_file"
    #remove https links, e.g. [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](https:\/\/[^)]*)/\1/g' "$new_file"
    #remove html tags, e.g. <AnyWord>
    sed -i '' 's/<[^>]*>//g' "$new_file"
    #remove "Back to" links
    grep -v '^Back to top$' "$new_file" > temp.md && mv temp.md "$new_file"
    #remove blank lines on top
    awk 'NF{p=1} p' "$new_file" > temp.md && mv temp.md "$new_file"
    #remove italic markdown footnotes *Anyword.*
    awk '/^!\[/ { p = 1; print; next } p && /^\*/ { p = 0; next } { p = 0 } 1' "$new_file" > temp.md && mv temp.md "$new_file"
    #move to tex folder
    mv "$new_file" "overleaf/${new_file//-tex/}"
  fi
done