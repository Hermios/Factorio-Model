import os,re,json
from github import Github
from dotenv import load_dotenv
from pathlib import Path
from urllib.request import urlopen,Request


#Get inputs
title=os.getenv('TITLE')
description=os.getenv('DESCRIPTION')
mod_author=os.getenv('MOD_AUTHOR')

mod_name=re.sub(r"([/\ '])","_",os.getenv('TITLE'))
mod_name=re.sub("-","",mod_name)

#Get Github token
token=os.getenv("GITHUB_TOKEN")

#Authenticate
github=Github(token)

#Create repo
template_repo=github.get_repo("Hermios/Factorio-Model")
post_parameters = {
    "name": mod_name,
    "owner": os.getenv("ACTOR"),
    "description": description,
    "include_all_branches":True
}

github.get_user()._requester.requestJsonAndCheck(
    "POST",
    f"/repos/{template_repo.owner.login}/{template_repo.name}/generate",
    input=post_parameters,
    headers={"Accept": "application/vnd.github.v3+json"},
)
new_repo=github.get_repo(f'{os.getenv("ACTOR")}/{mod_name}')

#Update readme
new_repo.update_file("README.md","init README.md","# *_Please send any request to Github (See Source URL!)_*",template_repo.get_readme().sha)

#Update modname
new_repo.create_file("constants.lua","create constants.lua",
  f'modname="{mod_name}"\ntech="tech-"..modname\nrecipe="recipe-"..modname\nsignal="signal-"..modname\nprototype="prototype-"..modname')


#Delete all existing labels
[label.delete() for label in new_repo.get_labels()] 

#Clone labels from model
[new_repo.create_label(label.name,label.color,label.description) for label in template_repo.get_labels()]

#Set secrets
new_repo.create_secret("FACTORIO_MOD_API_KEY",os.getenv("FACTORIO_MOD_API_KEY"))
new_repo.create_secret("OAUTH_TOKEN",token)

#Set variables
new_repo.create_variable("MOD_TITLE",title)
new_repo.create_variable("MOD_DESCRIPTION",description or " ")
with open(f"{os.getenv('APPDATA')}\\factorio\\player-data.json") as read_content:
  new_repo.create_variable("MOD_AUTHOR",mod_author)
new_repo.create_variable("MOD_DEPENDANCIES"," ")

req=Request("https://factorio.com/api/latest-releases",headers={'User-Agent' : "Magic Browser"})
with urlopen(req)  as response:
  factorio_release_data = json.loads(response.read())["experimental"]["alpha"].split(".")

factorio_version=factorio_release_data[0]+"."+factorio_release_data[1]

#Createw info.json
info_json={
"name": new_repo.name,
  "version": "0.0.1",
  "title": new_repo.get_variable("MOD_TITLE").value,
  "author": new_repo.get_variable("MOD_AUTHOR").value,
  "factorio_version": factorio_version
}
new_repo.create_file("info.json", "init info.json", json.dumps(info_json,indent=2))

# Clone branch
branch = new_repo.get_branch("master")
new_repo.create_git_ref(ref=f'refs/heads/dev', sha=branch.commit.sha)