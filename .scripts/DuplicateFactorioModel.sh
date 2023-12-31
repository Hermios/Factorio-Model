#!/bin/bash
read newMod
git clone --bare https://github.com/Hermios/Factorio-Model.git
cd Factorio-Model.git
git push --mirror https://github.com/EXAMPLE-USER/$newMod.git
cd ..
rm -rf Factorio-Model.git
