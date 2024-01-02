# How to use the Factorio Model
**__NOTE:__** This works only for Windows
## First time
1. Install Python (version 3 minimum) and pip
2. Install <a href=https://cli.github.com/>Github cli</a>
3. Install all necessary requirements: ```pip install -r ./scripts/requirements.txt```
4. Install Factorio and connect with your login/password (mandatory)
5. In the directory **%APPDATA%\Github CLI**, create a new file **.env**
6. In the file .env, add your <a href="https://factorio.com/profile">API Token</a> of Factorio, with the key **FACTORIO_MOD_API_KEY**
   
## Create a new mod
1. Run the python file python .scripts/DuplicateFactorioModel.py
2. Fill the name of the mod  
<em>**Note:**</em> characters /,\,' and space are automatically replaced in the mod/repository name with a _. However, the title remain
3. Fill the description
4. Validate
**__NOTE:__**: This will create a repository with 2 branches, **Master** and **Developer**. Master shall never be modified directly (It is locked anyway).
Other branches can be created, using Developer as basis.

⚠️This part is not ready yet
## Publish a new release of a mod
1. Implement code
2. update info.json **only with dependancies other than the base**
3. Push the changes to the corresponding branch
4. Create a pull request to the master
5. Add issues with labels (mandatory to fulfill the changelog)
6. Merge
---
**__NOTE:__** Version is updated based on quantity of issues and version of Factorio. Info.json and changelog.txt are updated automatically.
Then a release is created, and zip file is sent automatically to Factorio mods
--- 

