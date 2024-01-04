import os
import json
from github import Github
from pathlib import Path
import requests, zipfile, io

################################# Load data ###############################
# Get env data
pull_request=json.loads(os.environ["PULL_REQUEST"])
github=Github(os.environ["OAUTH_TOKEN"])
# Get Repository
repo=github.get_user().get_repo(pull_request["base"]["repo"]["name"])

zip_file_name=f"{repo.name}_{os.environ['RELEASE_VERSION']}"

################################# Extract zip file and remove non factorio content ###############################
with requests.get(repo.get_archive_link("zipball"), headers={"Authorization": f"token {token}"}) as r:
    z=zipfile.ZipFile(io.BytesIO(r.content))
    z.extractall(f"{zip_file_name}/")
    os.remove(z.filename)

# remove all non factorio directories
for p in Path(zip_file_name).glob("\..+"):
    p.unlink()
for p in Path(zip_file_name).glob(".+\.md"):
    p.unlink()

################################# Set info.json ###############################
try:
    mod_dependancies=json.loads(repo.get_variable("MOD_DEPENDANCIES").value)
except:
    mod_dependancies=[]
mod_dependancies.insert(0,f"base>={factorio_release}")

info_json={
  "name": repo.name,
  "version": os.environ['RELEASE_VERSION'],
  "title": repo.get_variable("MOD_TITLE").value,
  "author": repo.get_variable("MOD_AUTHOR").value,
  "homepage": repo.url,
  "dependencies": mod_dependancies,
  "description": repo.get_variable("MOD_DESCRIPTION").value,
  "factorio_version": os.environ['FACTORIO_RELEASE'][:factorio_release.rfind('.')]
}

# create info.json file
with open(f'{zip_file_name}/info.json','w') as info:
    info.write(json.dumps(info_json,indent=2))

################################# Set changelog ###############################
for release in repo.get_releases():
    changelog+=f"""---------------------------------------------------------------------------------------------------
Version: {release.tag_name}
Date: {release.created_at.strftime('%d-%m-%Y')}
{release.body}
"""
# create changelog file
with open(f'{zip_file_name}/changelog.txt','w') as info:
    info.write(changelog)

################################# create new zip file ###############################
directory = pathlib.Path(f"{zip_file_name}/")
with ZipFile(zip_file_name, "w") as archive:
    for file_path in directory.rglob("*"):
        archive.write(file_path, arcname=file_path.relative_to(directory))