import re
import subprocess
import json
import os
from github import Github
from dotenv import load_dotenv
from pathlib import Path


#Get inputs
title=input("Title of the mod? ")
description=input("Description? ") 
new_branch=input("Branch name(if empty, no branch will be created)? ")

mod_name=re.sub(r"([/\ '])","_",title)

#Load env file
load_dotenv(dotenv_path=Path(f"{os.getenv('APPDATA')}/GitHub CLI/.env"))

#Get Github token
token=subprocess.check_output("gh auth token",shell=True).decode('utf-8').replace("\n","")

#Authenticate
github=Github(token)

#Create repo
template_repo=github.get_repo("Hermios/Factorio-Model")
post_parameters = {
    "name": mod_name,
    "owner": github.get_user().login,
    "description": description,
    "include_all_branches":True
}

github.get_user()._requester.requestJsonAndCheck(
    "POST",
    f"/repos/{template_repo.owner.login}/{template_repo.name}/generate",
    input=post_parameters,
    headers={"Accept": "application/vnd.github.v3+json"},
)
new_repo=github.get_user().get_repo(mod_name)

#Delete readme
new_repo.update_file("README.md","init README.md","# *_Please send any request to Github (See Source URL!)_*",template_repo.get_readme().sha)

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
  new_repo.create_variable("MOD_AUTHOR",json.load(read_content)["service-username"])
new_repo.create_variable("MOD_DEPENDANCIES"," ")

#Createw info.json
info_json={
"name": new_repo.name,
  "version": "0.0.1",
  "title": new_repo.get_variable("MOD_TITLE").value,
  "author": new_repo.get_variable("MOD_AUTHOR").value
}
new_repo.create_file("info.json", "init info.json", json.dumps(info_json,indent=2))

# Clone branch
if new_branch!="":
  branch = new_repo.get_branch("master")
  new_repo.create_git_ref(ref=f'refs/heads/{new_branch}', sha=branch.commit.sha)