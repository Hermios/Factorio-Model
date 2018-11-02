local trainsTable={}
if global.trains then
	for trainID,trainData in pairs(global.trains) do
		trainsTable[trainID]=trainData
	end
	global.trains={}
	for trainID,trainData in pairs(trainsTable) do
		global.trains[trainID]={signals=trainData,sendCargo=true}
	end
end