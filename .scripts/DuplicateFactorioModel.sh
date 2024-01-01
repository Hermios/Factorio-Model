#!/bin/bash

#Get inputs
read -p "Title of the mod? " titleName
read -p "Description? " description

modName="${titleName// /_}"

#Create repo
newRep=gh repo create $modName -d "Factorio Mod: $description" --template https://github.com/Hermios/Factorio-Model.git --include-all-branches --public


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
gh secret set -f AppData/Roaming/GitHub\ CLI/.env -R $newRep
