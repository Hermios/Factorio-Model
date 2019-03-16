for key,value in pairs(global.listTrains) do
	global.listTrains[key].guiData=global.listTrains[key].guiData or value
end

for key,value in pairs(global.listTrainsStop) do
	global.listTrainsStop[key].guiData=global.listTrainsStop[key].guiData or value
end

for key,value in pairs(global.listTrainsAtStop) do
	global.listTrainsAtStop[key].globalData=global.listTrainsAtStop[key].globalData or {}
	global.listTrainsAtStop[key].globalData.guiData=global.listTrainsAtStop[key].globalData.guiData or value
end
