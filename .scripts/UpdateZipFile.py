import os,re
import json
from github import Github
from glob import glob
import requests, io
from zipfile import ZipFile
import shutil

################################# Load data ###############################
# Get env data
pull_request=json.loads(os.environ["PULL_REQUEST"])
github=Github(os.environ["OAUTH_TOKEN"])
# Get Repository
repo=github.get_user().get_repo(pull_request["base"]["repo"]["name"])

previous_zip_file_name=f"{repo.name}-{os.environ['RELEASE_VERSION']}"
zip_file_name=f"{repo.name}_{os.environ['RELEASE_VERSION']}"

################################# Extract zip file and remove non factorio content ###############################
with requests.get(f"https://github.com/{repo.full_name}/archive/refs/tags/{os.environ['RELEASE_VERSION']}.zip", headers={"Authorization": f"token {os.environ['OAUTH_TOKEN']}"}) as r:
    with open('release.zip', 'wb') as fh:
        fh.write(r.content)
with ZipFile('release.zip') as z:
    z.extractall()
os.remove('release.zip')
os.rename(previous_zip_file_name,zip_file_name)

# remove all non factorio directories
[shutil.rmtree(d) for d in glob(f"./{zip_file_name}/.*")]
os.remove(f"./{zip_file_name}/README.md")

################################# Set info.json ###############################
factorio_version=os.environ['FACTORIO_RELEASE'][:os.environ['FACTORIO_RELEASE'].rfind('.')]
mod_dependancies=[f"base>{os.environ['FACTORIO_RELEASE']}"]
try:
    list_dependancies=repo.get_variable("MOD_DEPENDANCIES").value
except:
    list_dependancies=""
for dependancy in list_dependancies.split('\r\n'):
    dependancy=dependancy.strip()
    if dependancy=="":
        continue
    elif dependancy.startswith("!"):
        mod_dependancies.append(dependancy)
    else:    
        mod=re.search("(\w+)",dependancy).group(1)
        with requests.get(f"https://mods.factorio.com/api/mods/{mod}") as response:
            last_version=None
            for release in response.json()["releases"]:
                if release["info_json"]["factorio_version"]==factorio_version:
                    last_version=release["version"]
            if not last_version:
                if not dependancy.startswith("?"):
                    print(f"mod unavailable for dependancy: {dependancy}")
                    exit(1) 
            else:
                mod_dependancies.append(f"{dependancy}>={last_version}")

info_json={
  "name": repo.name,
  "version": os.environ['RELEASE_VERSION'],
  "title": repo.get_variable("MOD_TITLE").value,
  "author": repo.get_variable("MOD_AUTHOR").value,
  "homepage": repo.html_url,
  "dependencies": mod_dependancies,
  "description": repo.get_variable("MOD_DESCRIPTION").value,
  "factorio_version": factorio_version
}

# create info.json file
with open(f'{zip_file_name}/info.json','w') as info:
    info.write(json.dumps(info_json,indent=2))

################################# Set changelog ###############################
changelog=""
for release in repo.get_releases():
    changelog+=f"""---------------------------------------------------------------------------------------------------
Version: {release.tag_name}
Date: {release.created_at.strftime('%d-%m-%Y')}
{release.body}"""

# create changelog file
with open(f'{zip_file_name}/changelog.txt','w') as info:
    info.write(changelog)

################################# create new zip file ###############################
with ZipFile(f"{zip_file_name}.zip", "w") as zf:
    for dirname, subdirs, files in os.walk(zip_file_name):
        zf.write(dirname)
        for filename in files:
            zf.write(os.path.join(dirname, filename))

################################# send mod ###############################
request_headers = {"Authorization": f"Bearer {os.environ['FACTORIO_MOD_API_KEY']}"}

# Get readmecontent
list_filenames=[f.filename for f in repo.get_pull(pull_request["number"]).get_files()]
readme=None
if "README.md" in list_filenames:
    readme=repo.get_contents("README.md").decoded_content.decode()

data={
    "mod": repo.name,
    "description": readme,
    "category":os.getenv("MOD_CATEGORY"),
    "license":os.getenv("MOD_LICENCE"),
    "source_url":repo.html_url
}

#Does mod exits
mod_exists=requests.get(f'https://mods.factorio.com/api/mods/{repo.name}').status_code==200

#Get list files to update
if mod_exists and readme is not None:
    response=requests.post("https://mods.factorio.com/api/v2/mods/edit_details",data=data, headers=request_headers)
    
    if not response.ok:
        print(f"edit failed: {response.text}")
        exit(1)
    
#Update url for mod exists or not
print("init upload")
init_end_point=f"https://mods.factorio.com/api/v2/mods/{'releases/init_upload' if mod_exists else 'init_publish'}"

response = requests.post(init_end_point, data={"mod":repo.name}, headers=request_headers)

if not response.ok:
    print(f"{'init_upload' if mod_exists else 'init_publish'} failed: {response.text}")
    exit(1)

upload_url = response.json()["upload_url"]
if not mod_exists:
    del data["mod"]

print("publish/upload")
with open(f"{zip_file_name}.zip", "rb") as f:
    request_body = {"file": f}
    response=requests.post(upload_url, files=request_body, data=data)

if not response.ok:
    print(f"upload failed: {response.text}")
    exit(1)

print(f"publication of mod {repo.name} successful:{response.url}")