local function isTrainRequired(station,trainData)
	if not stationItems[station.unit_number] then
		return nil
	end
	local trainContent=trainData.train.get_contents()
	for _,stationRequiredItem in pairs(stationItems[station.unit_number]) do		
		if trainContent[stationRequiredItem] and trainContent[stationRequiredItem]>0 then
			return stationRequiredItem
		end
	end
	return nil
end

function goToStation(train,trainStationName)
	if not train or not train.valid or not trainStationName or trainStationName=="" then
		return
	end	
	train.manual_mode=true
	train.schedule.current=0
	local wait_condition={type="time", ticks=30*60}
	local trainScheduleRecord={time_to_wait = 30, station=trainStationName}
	local schedule={current = 1, records = {trainScheduleRecord}}
	train.schedule=schedule
	train.manual_mode=false
end


function findStation(trainData)
	local currentStation= trainData.train.station 	
	--Does it stay at same station
	if currentStation and currentStation.valid==true and global.trainStations[currentStation.unit_number] and currentStation.backer_name~=trainData.defaultStation then
	--Current station still required this train
		local firstRequiredItem=isTrainRequired(currentStation,trainData)		
		if firstRequiredItem then
			if not global.trainStations[currentStation.unit_number].previousReadCargoState then
				global.trainStations[currentStation.unit_number].previousReadCargoState=trainData.train.station.get_control_behavior().read_from_train
				if remote.interfaces["TrainsSignalSender"] then
					remote.call("TrainsSignalSender","setSignals",trainData.train,{{signal={type="item",name=firstRequiredItem},count=1}})
				end
			end
			trainData.train.station.get_control_behavior().read_from_train=false
			return nil
		else
			if remote.interfaces["TrainsSignalSender"] then
				remote.call("TrainsSignalSender","clearSignals",trainData.train)
			end
			trainData.train.station.get_control_behavior().read_from_train=global.trainStations[currentStation.unit_number].previousReadCargoState or false
			global.trainStations[currentStation.unit_number].previousReadCargoState=nil
			global.trainStations[currentStation.unit_number].trainCalled=nil
		end
	end	
	--move to another station
	-- search for required call
	for key,data in pairs(global.trainStations) do
		firstRequiredItem=isTrainRequired(data.station,trainData)
		if data and not data.trainCalled and firstRequiredItem then
			data.trainCalled=trainData.train.id
			if remote.interfaces["TrainsSignalSender"] then
				remote.call("TrainsSignalSender","setSignals",trainData.train,{{signal={type="item",name=firstRequiredItem},count=1}})
			end
			return data.station.backer_name
		end
	end		
	--come back to default station
	if not currentStation or currentStation.backer_name~=trainData.defaultStation then	
		return trainData.defaultStation
	end
	return nil
end