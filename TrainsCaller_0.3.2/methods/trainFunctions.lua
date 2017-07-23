local function isTrainRequired(station,trainData)
	if not stationItems[station.unit_number] or #stationItems[station.unit_number]==0 then
		return nil
	end
	local trainContent=trainData.train.get_contents()
	local trainFluidContent=trainData.train.get_fluid_contents()
	for _,stationRequiredElement in pairs(stationItems[station.unit_number]) do
		if trainContent[stationRequiredElement.name] and trainContent[stationRequiredElement.name]>0 or trainFluidContent[stationRequiredElement.name] then
			return stationRequiredElement
		end
	end
	return nil
end

function goToStation(train,trainStationName)
	if not train or not train.valid or not trainStationName or trainStationName=="" or (train.schedule and #train.schedule.records>0 and train.schedule.records[1].station==trainStationName) then
		return
	end	
	train.manual_mode=true
	local wait_condition={type="time", ticks=30*60}
	local trainScheduleRecord={time_to_wait = 30, station=trainStationName}
	train.schedule={current = 1, records = {trainScheduleRecord}}
	train.manual_mode=false
end


function findStation(trainData)
	local currentStation= trainData.train.station 
	--Does it stay at same station
	if currentStation and currentStation.valid==true and global.trainStations[currentStation.unit_number] and currentStation.backer_name~=trainData.defaultStation then
	--Current station still required this train
		local firstRequiredElement=isTrainRequired(currentStation,trainData)
		if firstRequiredElement then
			if remote.interfaces["TrainsSignalSender"]  and (not trainData.RequiredItem or trainData.RequiredItem~=firstRequiredElement) then
				remote.call("TrainsSignalSender","clearSignals",trainData.train)
				remote.call("TrainsSignalSender","setSignals",trainData.train,{{signal=firstRequiredElement,count=1}})
				trainData.RequiredItem=firstRequiredElement
				if not global.trainStations[currentStation.unit_number].previousReadCargoState then
					global.trainStations[currentStation.unit_number].previousReadCargoState=trainData.train.station.get_control_behavior().read_from_train	
				end
			end
			trainData.train.station.get_control_behavior().read_from_train=false
			return nil
		else
			if remote.interfaces["TrainsSignalSender"] then
				remote.call("TrainsSignalSender","clearSignals",trainData.train)
			end
			trainData.RequiredItem=nil
			trainData.train.station.get_control_behavior().read_from_train=global.trainStations[currentStation.unit_number].previousReadCargoState or false
			global.trainStations[currentStation.unit_number].previousReadCargoState=nil
			global.trainStations[currentStation.unit_number].trainCalled=nil
		end
	end	
	--move to another station
	-- search for required call
	for key,data in pairs(global.trainStations) do
		firstRequiredElement=isTrainRequired(data.station,trainData)
		if data and (not data.trainCalled or data.trainCalled==trainData.train.id) and firstRequiredElement then
			data.trainCalled=trainData.train.id
			if remote.interfaces["TrainsSignalSender"] then
				remote.call("TrainsSignalSender","setSignals",trainData.train,{{signal=firstRequiredElement,count=1}})
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