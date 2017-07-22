function OnTickSetCall()
	if player.force.technologies[trainCallerTech].researched and not global.trains then
		global.trains={}
	end
	if not global.trains then
		return
	end	
	getStationRequiredItems()
	for id,data in pairs(global.trains) do
		local train=data.train
		--if train available
		if train and train.valid then
			--if train available, search for the next station
			if  train.state==defines.train_state.no_schedule or
				train.state==defines.train_state.no_path or
				train.state==defines.train_state.wait_station or
				train.state==defines.train_state.manual_control_stop or
				train.state==defines.train_state.manual_control 
			then
				local destination=findStation(data)
				if destination then
					goToStation(train,destination)
				end
			end
		elseif not train or not train.valid then
			table.remove(global.trains,id)
		end
	end
end

trainStopEntity.OnBuilt=function(entity)
	if global.trainStations then
		global.trainStations[entity.unit_number]={callActivated=false,station=entity,trainCalled=false}
	end
end

trainStopEntity.OnRemoved=function(entity)
	if global.trainStations and global.trainStations[entity.unit_number] then
		table.remove(global.trainStations,entity.unit_number)
	end
end

OnTrainCreated=function(train)
	if not global.trains then
		return
	end
	for _,loco in pairs(train.locomotives.front_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				global.trains[train.id]={defaultStation=nil,train=train,item1=nil,comparator="=",item2=nil}
				return
			end
		end
	end
	for _,loco in pairs(train.locomotives.back_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				global.trains[train.id]={defaultStation=nil,train=train,item1=nil,comparator="=",item2=nil}
				return
			end
		end
	end
end

trainCallerEquip.OnEquipmentPlaced=function(equipment)
	local currentGuiEntity=player.opened
	if not global.trains or global.trains[currentGuiEntity.train.id] then
		return
	end
	if currentGuiEntity and not global.trains[currentGuiEntity.train.id] then
		global.trains[currentGuiEntity.train.id]={defaultStation=nil,train=currentGuiEntity.train,item1=nil,comparator="=",item2=nil}
	end	
end

trainCallerEquip.OnEquipmentRemoved=function(equipment)
	if not global.trains then
		return
	end
	local currentGuiEntity=player.opened
	if not currentGuiEntity or not GuiEntities[currentGuiEntity.type] then
		return
	end
	for _,equipment in pairs(currentGuiEntity.grid.equipment) do
		if equipment.name==trainCallerEquipment then
			return
		end
	end
	local currentFrame=getFrame(LeftGui,currentGuiEntity)
	if currentFrame then
		currentFrame.destroy()
	end
	if global.trains[currentGuiEntity.train.id] then
		global.trains[currentGuiEntity.train.id]=nil
	end
end