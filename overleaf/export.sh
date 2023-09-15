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
  if [[ -f "$file" ]]; then
    #removing markdown links, e.g. [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](#\([^)]*\))/\1/g' "$file"
    #removing https links, e.g. [Devops](#devops)    
    sed -i '' 's/\[\([^]]*\)\](https:\/\/[^)]*)/\1/g' "$file"
    #remove html tags, e.g. <AnyWord>
    sed -i '' 's/<[^>]*>//g' "$file"
    #remove "Back to" links
    #sed -i '' 's/^[^#]*#/#/g' "$file"
  fi
done

#remove "Back to" links
awk '/^# / {p=1} p' booking-system.md > newfile.md
