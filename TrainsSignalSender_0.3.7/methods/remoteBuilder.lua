setSignals= function (train,signalIds)
	if not listTrains[train.id] then
		return
	end
	for _,signalId in pairs(signalIds) do
		table.insert(listTrains[train.id].globalData.guiData.signals,signalId)
	end
end

clearSignals= function (train)
	if listTrains[train.id] then
		listTrains[train.id].globalData.guiData.signals={}
	end
end

getSignals=function(train)
	if listTrains[train.id] then
		return listTrains[train.id].globalData.guiData.signals
	end
end

hasSignal=function(train,signalId)
	if not listTrains[train.id] then
		return
	end
	for _,trainSignalId in pairs(listTrains[train.id].globalData.guiData.signals) do
		if trainSignalId.signal and trainSignalId.signal.name==signalId.name then				
			return true
		end
	end
	return false
end

function InitRemote()
remote.add_interface
	(ModName,
		{
			setSignals=setSignals,
			clearSignals=clearSignals,
			getSignals=getSignals,
			hasSignal=hasSignal
		}
	)
end