#!/bin/bash

#Get inputs
read -p "Name of the mod? " modName
read -p "Title of the mod? " titleName
read -p "Description? " description

#Create repo
gh repo create $modName -d "Factorio Mod: $description" --template https://github.com/Hermios/Factorio-Model.git --include-all-branches --public

#Delete all existing labels
labels=$(gh label list -R Hermios/$modName --json name)
jq -c '.[]' <<< $labels | while read i
do 
  label=$(jq '.name '<<< $i | tr -d '"')
  gh label delete "$label" --yes -R Hermios/$modName
done

#Clone labels from model
gh label clone Hermios/Factorio-Model -R Hermios/$modName

#Clone secrets
gh secret set -f AppData/Roaming/GitHub\ CLI/.env -R Hermios/Test

#Update info.json 
curl https://raw.githubusercontent.com/Hermios/Factorio-Model/developer/info.json --output info.json
