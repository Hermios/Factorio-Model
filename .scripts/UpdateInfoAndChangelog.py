import os
import json
from github import Github
from urllib.request import urlopen 
from datetime import datetime

################################# Load data ###############################
pull_request=json.loads(os.env("PULL_REQUEST"))
github=Github(os.env("GITHUB_TOKEN"))
repo=github.get_user().get_repo(pull_request.repo.name)
repo_release_data=list(map(lambda v:int(v),(repo.get_latest_release() or "1.0.0").split(".")))

with urlopen("https://factorio.com/api/latest-releases")  as response:
  factorio_release_data = list(map(lambda v:int(v),json.loads(response.read()).experimental.alpha.split(".")))

# Get issues for current pull_request
issues=dict()
for issue in filter(lambda i:i.pull_request is None and i.closed_at==pull_request.closed_at,repo.get_issues(state="closed",sort="closed_at")):
    issues.set_default(issue.labels[0],[])
    issues[issue.labels[0]].append(f'{issue.title}[{issue.url}]')

################################# Set new release ###############################
# Set new repo_release_data
if factorio_release_data[0]>repo_last_data[0]:
    repo_release_data=[factorio_release_data[0],0,0]
elif sum(len(v) for v in issues.itervalues())>=5:
    repo_release_data[1]+=1
    repo_release_data[2]=0
else:
    repo_release_data[2]+=1
release_tag=".".join(list(map(lambda v:str(v),repo_release_data)))
release_body=""
for issue in issues:
    release_body+=f"""
      {issue}
    """
    for detail in issues[issue]:
        release_body+=f"""
            - {detail}
        """
################################# Set changelog ###############################
changelog=f"""
    ---------------------------------------------------------------------------------------------------
    Version: {release_tag}
    Date: {datetime.fromisoformat(pull_request.closed_at).strftime('%d-%m-%Y')}
    {release_body}

    """
for release in repo.get_releases():
    changelog+=f"""
    ---------------------------------------------------------------------------------------------------
    Version: {release.tag}
    Date: {datetime.fromisoformat(release.created_at).strftime('%d-%m-%Y')}
    {release.comment}

    """
print(changelog)