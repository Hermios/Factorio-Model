import os

list_mods=[]
with urllib.request.urlopen(os.env["PULL_URL"]+"/files") as url:
    list_mods=list(map(lambda x: x["filename"].split("/")[0],json.load(url)))