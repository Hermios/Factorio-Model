jsonFile="$1/info.json"
jsonString=`cat $jsonFile`
currentVersion=$(jq -r '.version' <<< "$jsonString")
IFS='.' read -ra VersionData <<< "$currentVersion"
VersionData[$2]=expr ${VersionData[$2]}+1
newVersion=${VersionData[0]}.${VersionData[1]}.${VersionData[2]}

jq -c '.version = "$newVersion"' $jsonFile > tmp.$$.json && mv tmp.$$.json $jsonFile
