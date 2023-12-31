import os
import re
import urllib.request, json 
list_issues=os.env["LIST_ISSUES"]
dictionaryModVersionLevel=dict()

for issue in list_issues:
    number=re.search(r".+#(\d+)",issue).group(1)
    with urllib.request.urlopen(os.env["ISSUE_URL"].replace("{/number}","/"+number)) as url:
        data=json.load(url)
        mod = re.search(r"[(.*)?]",data.title).group(1)
        dictionaryModVersionLevel[mod]=dictionaryModVersionLevel.get(mod,2)
        if dictionaryModVersionLevel[mod]==2:
            for label in data.labels:
                if label.name == "minor":
                    dictionaryModVersionLevel[mod]=1

return dictionaryModVersionLevel