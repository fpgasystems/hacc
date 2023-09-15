#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

#constants
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

#remove all md
rm *.md

#copy all md
cp ../docs/*.md $DIR

sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' vocabulary.md

for file in *.md; do
  if [[ -f "$file" ]]; then
    #removing markdown links, e.g. [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' "$file"
    #removing https links, e.g. [Devops](#devops)    
    sed -i '' 's/\[\([^]]*\)\](https:\/\/[^)]*)/\1/g' "$file"
    #remove html tags, e.g. <AnyWord>
    sed -i '' 's/<[^>]*>//g' "$file"
    #remove "Back to" links
    #sed -i '' 's/^[^#]*#/#/g' "$file"
    #remove "Back to" links
    #awk '/^# / {p=1} p' booking-system.md > newfile.md
    #sed -i '/Back to top/ { :a; N; /Back to top\n$/d; ba; }' "$file"
    grep -v '^Back to top$' "$file" > temp.md && mv temp.md "$file"
    #remove blank lines on tope
    awk 'NF{p=1} p' "$file" > temp.md && mv temp.md "$file"
  fi
done