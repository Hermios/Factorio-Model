#!/bin/bash
read modName
read description
gh repo create $modName -d "Factorio Mod: $description" --template https://github.com/Hermios/Factorio-Model.git --include-all-branches --public
