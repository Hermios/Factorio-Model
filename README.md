# How to use the Factorio Model
⚠️ This works only for Windows
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
<em>**Note:**</em> characters /,\\,' and space are automatically replaced in the mod/repository name with a _. However, the title remain
3. Fill the description
4. Fill the name of the branch to add (Optional)
5. Validate
6. In Info.json, update the factorio_version if necessary (Default:1.0)
___
ℹ️ This will create a repository with a branche Master. this one shall never be modified directly.
A RREADME.md file is created, but empty. When publishing, its content is added as detailed description of the mod 
The info.json file is as well created, but only for development. **Other than <em>factorio_version</em>**,it is useless to fulfill it properly, as it will be overwritten during the publish process
Other branches can be created, using Master as basis.
___
## Publish a new release of a mod
1. Implement code
2. If necessary, update the dependancies in the environment variable **MOD_DEPENDANCIES**, with format list json.
___
ℹ️ To add dependancy, simply add the name of the mod, with signs !,? or ~ if necessary. if sign !, it will simply be added. For other signs, the last release of the mod is automatically added, if compatible with current factorio version. If no mod is available for this version of Factorio, and the mod is mandatory, this generate an error  
⚠️Don't add dependancy to the base, this one is handled automatically
___
   
4. Push the changes to the corresponding branch
5. Create a pull request to the master
6. Add issues with labels **(mandatory)**  
<em>**Note:**</em>Issues are used to create changelog. The label of the issue is the type of change, while its title is the description of the change + the url of the issue
8. Merge
___
ℹ️ This will create a new release for the repo, which description is the changelog content. Then, the content as zip is downloaded, changelog and info.json file are automatically generated, included into the zip which is then sent to Factorio
___
