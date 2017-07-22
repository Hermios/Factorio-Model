trainEntity.CanOpenGui=function(entity)
	if not global.trains then
		return false
	end
	for _,equipment in pairs(entity.grid.equipment) do
		if equipment.name==trainCallerEquipment then
			return true
		end
	end
	return false
end

trainEntity.UpdateGui=function(entity)
	if not global.trains or not global.trains[entity.train.id] then
		global.trains[entity.train.id]={train=entity.train,defaultStation=nil}
	end
	local dropDown=getFrame(LeftGui,{entity,"stationsDropDown"})
	dropDown.clear_items()
	dropDown.add_item({"select-a-station"})
	local selectedIndex=1
	local currentIndex=1
	local defaultStation=nil
	if global.trains[player.opened.train.id] then
		defaultStation=global.trains[player.opened.train.id].defaultStation
	end
	for index,stationData in pairs(global.trainStations) do
		if stationData.station and stationData.station.valid then
			currentIndex=currentIndex+1
			dropDown.add_item(stationData.station.backer_name)
			if stationData.station.backer_name==defaultStation then
				selectedIndex=currentIndex
			end
		else
			global.trainStations[index]=nil
		end
	end
	dropDown.selected_index=selectedIndex
end

trainEntity.UpdateFromGui=function(entity)	
	if not global.trains[entity.train.id] or not global.trains[entity.train.id] then
		global.trains[entity.train.id]={train=entity.train,defaultStation=nil}
	end	
	local dropDownFrame=getFrame(LeftGui,{entity,"stationsDropDown"})
	if dropDownFrame.selected_index==0 then
		global.trains[entity.train.id].defaultStation=nil
	else
		global.trains[entity.train.id].defaultStation=dropDownFrame.get_item(dropDownFrame.selected_index)
	end
end

trainStopEntity.CanOpenGui=function(entity)
	return global.trainStations
end

trainStopEntity.UpdateGui=function(entity)
	if not global.trainStations[entity.unit_number] then
		global.trainStations[entity.unit_number]={networkCallActivated=false,circuitCallActivated=false,trainCalled=false,station=entity,circuitConditions={}}
	end
	getFrame(LeftGui,{entity,"activateNetworkCheckbox"}).state=global.trainStations[entity.unit_number].networkCallActivated
	getFrame(LeftGui,{entity,"activateCircuitCheckbox"}).state=global.trainStations[entity.unit_number].circuitCallActivated
	if not global.trainStations[entity.unit_number].circuitConditions then
		global.trainStations[entity.unit_number].circuitConditions={}
	end
	for i,circuitCondition in pairs(global.trainStations[entity.unit_number].circuitConditions) do
		addToFrame(getFrame(LeftGui,{entity,"trainStopConditions"}),{conditionGui.new(i)})
		local guiComparatorElement=getFrame(LeftGui,{entity,"trainStopConditions","conditionFlow."..i,"signal.comparator"})
		for index,item in pairs(guiComparatorElement.items) do
			if item==circuitCondition.comparator then
				guiComparatorElement.selected_index=index
			end
		end
		guiElementEntities["signal1."..i].Set(circuitCondition.signal1)
		guiElementEntities["signal2."..i].Set(circuitCondition.signal2)
		guiElementEntities["signal3."..i].Set(circuitCondition.resultSignal)
	end
end

trainStopEntity.UpdateFromGui=function(entity)
	local element=getFrame(LeftGui,{entity,"station.checkbox"})
	global.trainStations[entity.unit_number].networkCallActivated=getFrame(LeftGui,{entity,"activateNetworkCheckbox"}).state
	global.trainStations[entity.unit_number].circuitCallActivated=getFrame(LeftGui,{entity,"activateCircuitCheckbox"}).state
	global.trainStations[entity.unit_number].circuitConditions={}
	for _,childName in pairs(getFrame(LeftGui,{entity,"trainStopConditions"}).children_names) do
		local i=string.match(childName,".+conditionFlow%.(%d+)")
		local condition={}
		local guiComparatorElement=getFrame(LeftGui,{entity,"trainStopConditions","conditionFlow."..i,"signal.comparator"})
		condition.comparator=guiComparatorElement.get_item(guiComparatorElement.selected_index)
		condition.signal1=guiElementEntities["signal1."..i].value
		condition.signal2=guiElementEntities["signal2."..i].value
		condition.resultSignal=guiElementEntities["signal3."..i].value
		if condition.signal1 and condition.signal2 and condition.resultSignal then
			table.insert(global.trainStations[entity.unit_number].circuitConditions,condition)
		end		
	end
end