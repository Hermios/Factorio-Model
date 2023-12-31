#!/bin/bash
read modName
read description
gh repo create $modName -d "Factorio Mod: $description"
git clone --bare https://github.com/Hermios/Factorio-Model.git
cd Factorio-Model.git
git push --mirror https://github.com/EXAMPLE-USER/$modName.git
cd ..
rm -rf Factorio-Model.git
