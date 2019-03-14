for key,value in pairs(global.listTrains) do
	global.listTrains[key].guiData=global.listTrains[key].guiData or value
end

for key,value in pairs(global.listRails) do
	global.listRails[key].guiData=global.listRails[key].guiData or value
end

for key,value in pairs(global.listRailPoleConnectors) do
	global.listRailPoleConnectors[key].guiData=global.listRailPoleConnectors[key].guiData or value
end