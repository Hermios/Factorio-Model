import os
import json
from github import Github
from urllib.request import urlopen,Request
from datetime import datetime

################################# Load data ###############################
pull_request=json.loads(os.environ["PULL_REQUEST"])
github=Github(os.environ["OAUTH_TOKEN"])
repo=github.get_user().get_repo(pull_request["base"]["repo"]["name"])
try:
    repo_release=repo.get_latest_release()
except:
    repo_release="0.0.0"
repo_release_data=list(map(lambda v:int(v),repo_release.split(".")))

req=Request("https://factorio.com/api/latest-releases",headers={'User-Agent' : "Magic Browser"})
with urlopen(req)  as response:
  factorio_release = json.loads(response.read())["experimental"]["alpha"]

# Get issues for current pull_request
issues=dict()
print(os.environ["LIST_ISSUES"])
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

################################# Set changelog ###############################
changelog=f"""---------------------------------------------------------------------------------------------------
Version: {release_version}
Date: {datetime.fromisoformat(pull_request["closed_at"]).strftime('%d-%m-%Y')}
"""
for issue in issues:
    changelog+=f"  {issue}\n"
    for detail in issues[issue]:
        changelog+=f"    - {detail}\n"

for release in repo.get_releases():
    changelog+=f"""---------------------------------------------------------------------------------------------------
Version: {release.tag}
Date: {datetime.fromisoformat(release.created_at).strftime('%d-%m-%Y')}
{release.comment}
"""