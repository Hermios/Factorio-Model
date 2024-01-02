# How to use the Factorio Model
**__NOTE:__** This works only for Windows
## First time
1. Install Python (version 3 minimum) and pip
2. Install Github cli
3. Install all necessary requirements: ```pip install -r ./scripts/requirements.txt```
4. Install Factorio and connect with your login/password (mandatory)
5. In the directory **%APPDATA%\Github CLI**, create a new file **.env**
6. In the file .env, add your API Token of Factorio (https://factorio.com/profile), with the key **FACTORIO_MOD_API_KEY**
   
## Create a new mod
1. Run the python file python .scripts/DuplicateFactorioModel.py
2. Fill the name of the mod
 <em>**Note:**</em> characters /,\,' and space are automatically replaced in the mod/repository name with a _. However, the title remain
3. Fill the description
4. Validate
**__NOTE:__**: This will create a repository with 2 branches, **Master** and **Developer**. Master shall never be modified directly (It is locked anyway).
Other branches can be created, using Developer as basis.
 

