#!/bin/bash
read newMod
git clone --bare https://github.com/EXAMPLE-USER/OLD-REPOSITORY.git
cd OLD-REPOSITORY.git
git push --mirror https://github.com/EXAMPLE-USER/NEW-REPOSITORY.git
cd ..
rm -rf OLD-REPOSITORY.git
