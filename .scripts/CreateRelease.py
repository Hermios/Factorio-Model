import os
import json
from github import Github
from urllib.request import urlopen,Request
from datetime import datetime

################################# Load data ###############################
# Get env data
pull_request=json.loads(os.environ["PULL_REQUEST"])
github=Github(os.environ["OAUTH_TOKEN"])

# Get Repository
repo=github.get_user().get_repo(pull_request["base"]["repo"]["name"])
try:
    repo_release=repo.get_latest_release()
except:
    repo_release="0.0.0"
repo_release_data=list(map(lambda v:int(v),repo_release.tag_name.split(".")))

req=Request("https://factorio.com/api/latest-releases",headers={'User-Agent' : "Magic Browser"})
with urlopen(req)  as response:
  factorio_release = json.loads(response.read())["experimental"]["alpha"]

# Get issues for current pull_request
issues=dict()
for issueNumber in list(map(lambda issue: int(issue.split("#")[1]),json.loads(os.environ["LIST_ISSUES"]))):
    issue=repo.get_issue(issueNumber)
    issues.setdefault(issue.labels[0].name,[])
    issues[issue.labels[0].name].append(f'{issue.title}[{issue.url}]')

################################# Set new release ###############################
# Set new repo_release_data
factorio_release_version=int(factorio_release.split(".")[0])
if factorio_release_version>repo_release_data[0]:
    repo_release_data=[factorio_release_version,0,0]
elif sum(len(v) for v in issues.values())>=5:
    repo_release_data[1]+=1
    repo_release_data[2]=0
else:
    repo_release_data[2]+=1
release_version=".".join(list(map(lambda v:str(v),repo_release_data)))

################################# Set info.json ###############################
try:
    mod_dependancies=json.loads(repo.get_variable("MOD_DEPENDANCIES").value)
except:
    mod_dependancies=[]
mod_dependancies.insert(0,f"base>={factorio_release}")

info_json={
  "name": repo.name,
  "version": release_version,
  "title": repo.get_variable("MOD_TITLE").value,
  "author": repo.get_variable("MOD_AUTHOR").value,
  "homepage": repo.url,
  "dependencies": mod_dependancies,
  "description": repo.get_variable("MOD_DESCRIPTION").value,
  "factorio_version": factorio_release[:factorio_release.rfind('.')]
}
try:
    sha=repo.get_contents("info.json").sha
    repo.update_file("info.json","Create info.json",json.dumps(info_json,indent=1),sha=sha)
except:
    repo.create_file("info.json","Create info.json",json.dumps(info_json,indent=1))
################################# Set changelog ###############################
# last release message
last_release_text=""
for issue in issues:
    last_release_text+=f"  {issue}\n"
    for detail in issues[issue]:
        last_release_text+=f"    - {detail}\n"
last_release_text+="\n"

# changelog
changelog=f"""---------------------------------------------------------------------------------------------------
Version: {release_version}
Date: {datetime.now().strftime('%d-%m-%Y')}
{last_release_text}
"""

for release in repo.get_releases():
    changelog+=f"""---------------------------------------------------------------------------------------------------
Version: {release.tag_name}
Date: {release.created_at.strftime('%d-%m-%Y')}
{release.body}
"""
# update changelog
try:
    sha=repo.get_contents("changelog.txt").sha
    repo.update_file("changelog.txt","Create changelog.txt",changelog,sha=sha)
except:
    repo.create_file("changelog.txt","Create changelog.txt",changelog)

# create release
repo.create_git_release(tag=release_version,name="", message=last_release_text)