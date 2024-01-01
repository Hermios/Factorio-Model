#!/bin/bash

#Get inputs
read -p "Title of the mod? " title
read -p "Description? " description

modName="${title// /_}"

#Create repo
newRep=$(gh repo create $modName -d "Factorio Mod: $description" -c --template https://github.com/Hermios/Factorio-Model.git --include-all-branches --public)


#Delete all existing labels
labels=$(gh label list -R $newRep --json name)
jq -c '.[]' <<< $labels | while read i
do 
  label=$(jq '.name '<<< $i | tr -d '"')
  gh label delete "$label" --yes -R $newRep
done

#Clone labels from model
gh label clone Hermios/Factorio-Model -R $newRep

#Clone secrets
gh secret set -f "$APPDATA\GitHub CLI\.env" -R $newRep

#Create info.json
$(jq -n /
  '{"name": "$modName", 
    "title": "$title",
    "author": "Hermios",
    "homepage": "https//github.com/Hermios/$modName",
    "description": "$description",
  }') > info.json

#Push info.json to the repo
git add info.json
git commit -m "init"
git push -u origin developer
#Delete info.json
del info.json