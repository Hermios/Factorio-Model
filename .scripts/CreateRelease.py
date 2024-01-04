import os
import json
from github import Github
from urllib.request import urlopen,Request
from datetime import datetime

################################# Load global data ###############################
# Get env data
pull_request=json.loads(os.environ["PULL_REQUEST"])
github=Github(os.environ["OAUTH_TOKEN"])

# Get Repository
repo=github.get_user().get_repo(pull_request["base"]["repo"]["name"])


################################# Get release data ###############################
try:
    repo_release=repo.get_latest_release().tag_name
except:
    repo_release="0.0.0"
repo_release_data=list(map(lambda v:int(v),repo_release.split(".")))

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
################################# Create release ###############################
# last release message
last_release_text=""
for issue in issues:
    last_release_text+=f"  {issue}\n"
    for detail in issues[issue]:
        last_release_text+=f"    - {detail}\n"
last_release_text+="\n"

# create release
repo.create_git_release(tag=release_version,name=pull_request["title"], message=last_release_text)

# Store datga in env
env_file_name = os.getenv('GITHUB_ENV')
with open(env_file_name, "a") as env_file:
    env_file.write(f"RELEASE_VERSION={release_version}\n")
    env_file.write(f"FACTORIO_RELEASE={factorio_release}\n")