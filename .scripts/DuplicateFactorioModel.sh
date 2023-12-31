#!/bin/bash
read -p "Name of the mod? " modName
read -p "Description? " description
gh repo create $modName -d "Factorio Mod: $description" --template https://github.com/Hermios/Factorio-Model.git --include-all-branches --public

#Delete all existing labels
labels=$(gh label list -R Hermios/$modName --json name)
jq -c '.[]' <<< $labels | while read i
do 
  label=$(jq '.name '<<< $i | tr -d '"')
  gh label delete --yes $label -R Hermios/$modName
done
gh label clone Hermios/Factorio-Model -R Hermios/$modName
