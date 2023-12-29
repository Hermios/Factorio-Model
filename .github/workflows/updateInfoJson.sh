jsonFile="$1/info.json"
jsonString=`cat $jsonFile`
currentVersion=$(jq -r '.version' <<< "$jsonString")
echo currentVersion:"$currentVersion"
versionLevel=$(($2 + 0))
echo versionLevel:"$versionLevel"
IFS='.' read -ra VersionData <<< "$currentVersion"
VersionData[$versionLevel]=expr ${VersionData[$versionLevel]}+1
for i in (versionLevel+1..2)
do
  VersionData[$versionLevel]=0
done
newVersion=${VersionData[0]}.${VersionData[1]}.${VersionData[2]}

jq -c '.version = "$newVersion"' $jsonFile > tmp.$$.json && mv tmp.$$.json $jsonFile
