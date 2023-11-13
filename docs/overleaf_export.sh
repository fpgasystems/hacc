#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Constants
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the directory
cd "$DIR"

# Remove overleaf directory
if [ -d "$DIR/overleaf" ]; then
    rm -r "$DIR/overleaf"
fi

# Create overleaf directory
mkdir "$DIR/overleaf"

# Export to overleaf
for file in *.md; do  
  if [[ -f "$file" ]]; then
    # Create a new file with a modified name
    new_file="${file%.md}-tex.md"
    cp "$file" "$new_file"
    # Remove markdown links, e.g., [Devops](#devops)
    sed -i '' 's/\[\([^]]*\)\](\([^)]*#.*\))/**\1**/g' "$new_file"
    # Remove https links, e.g., [Devops](https://example.com)
    sed -i '' 's/\[\([^]]*\)\](https:\/\/[^)]*)/**\1**/g' "$new_file"
    # Remove email links, e.g., [AnyEmailAccount](mailto: AnyEmailAccount)
    sed -i '' 's/\[\([^]]*\)\](mailto:[^)]*)/\1/g' "$new_file"
    # Add \url to Any.Name@Any.Domain
    #sed -i '' -E 's/([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+)/\\url{\1}/g' "$new_file"
    # Remove HTML tags, e.g., <AnyWord>
    sed -i '' 's/<[^>]*>//g' "$new_file"
    # Remove "Back to" links
    grep -v '^Back to top$' "$new_file" > temp.md && mv temp.md "$new_file"
    # Remove blank lines at the top
    awk 'NF{p=1} p' "$new_file" > temp.md && mv temp.md "$new_file"
    # Remove italic markdown footnotes *Anyword.*
    awk '/^!\[/ { p = 1; print; next } p && /^\*/ { p = 0; next } { p = 0 } 1' "$new_file" > temp.md && mv temp.md "$new_file"
    # Replace ```AnyString``` with bold **AnyString**
    sed -i '' 's/```\([^`]*\)```/**\1**/g' "$new_file"
    # Replace ../imgs with ./
    sed -i '' 's/\.\.\/imgs\//\.\//g' "$new_file"
    # Move to the tex folder
    mv "$new_file" "overleaf/${new_file//-tex/}"
  fi
done