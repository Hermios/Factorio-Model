local function createGhostStation(position,direction)
	local trainStation=game.surfaces[1].create_entity{
		name=trainStopGhost,
		force=player.force,
		position=position,
		direction=direction
	}
	trainStation.destructible=false
	trainStation.minable=false
	trainStation.operable=false
	return trainStation
end
local noTrain=true
local function findTrainForStation(station)
	noTrain=true
	for id,data in pairs(global.trains) do
		local train=data.train
		if train.valid then
			noTrain=false
			if not data.station then
				train.schedule.current=0
				local wait_condition={type="time", ticks=30*60}
				local trainScheduleRecord={time_to_wait = 30, station=station.backer_name}
				train.schedule={current = 1, records = {trainScheduleRecord}}
				if train.has_path then
					global.trains[id].station=station
					return train
				else
					train.manual_mode=true
					train.schedule.current = 0
					train.schedule.records={}
					train.manual_mode=false
				end
			end
		else
			global.trains[id]=nil
		end
	end
end

OnStateChanged=function(train)
	if global.trains and global.trains[train.id] and global.trains[train.id].station and (global.trains[train.id].station==train.station or not train.has_path) then
		global.trains[train.id].station.destroy()
		global.trains[train.id].station=nil
		train.manual_mode=true
		train.schedule.current = 0
		train.schedule.records={}
	end
end

OnTrainCreated=function(train)
	if not global.trains then
			return
		end
	for _,loco in pairs(train.locomotives.front_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainWhistleEquipment then
				global.trains[train.id]={train=loco.train}
				return
			end
		end
	end
	for _,loco in pairs(train.locomotives.back_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainWhistleEquipment then
				global.trains[train.id]={train=loco.train}
				return
			end
		end
	end
end

railEntity.OnWhilsteDo=function(event)
	if not global.trains then
		return
	end				
	local rail=player.selected
	local pos1=rail.position
	local pos2=rail.position
	if rail.direction==0 then
		pos1.x=pos1.x+2
		pos2.x=pos1.x-5
	elseif rail.direction==2 then
		pos1.y=pos1.y+2
		pos2.y=pos1.y-5
	else
		return
	end
	local trainStation=createGhostStation(pos2,rail.direction+4)
	
	local train=findTrainForStation(trainStation)
	if noTrain then
		player.print({"NO_TRAIN"})
		return
	end
	if not train then
		trainStation.destroy()
		trainStation=createGhostStation(pos1,rail.direction)
		train=findTrainForStation(trainStation)
	end
	if not train then
		trainStation.destroy()
		player.print({"NO_TRAIN_REACH"})
		else
		player.print({"train_ok",math.floor(distance(train.locomotives.front_movers[1],trainStation))})
	end
end

trainEntity.OnRemoved=function(entity)
	if not global.trains then
		return
	end
	for index,trainData in pairs(global.trains) do
		if not trainData.train or trainData.train.valid then
			trainData.station.destroy()
			global.trains[index]=nil
		end
	end
end

trainWhistleEquip.OnEquipmentPlaced=function(equipment)
player.print("test")
	local currentGuiEntity=player.opened
	if not global.trains or global.trains[currentGuiEntity.train.id] then
		return
	end
	if currentGuiEntity and not global.trains[currentGuiEntity.train.id] then
		global.trains[currentGuiEntity.train.id]={train=currentGuiEntity.train}
	end	
end

trainWhistleEquip.OnEquipmentRemoved=function(equipment)
	if not global.trains then
		return
	end
	local currentGuiEntity=player.opened
	if not currentGuiEntity then
		return
	end
	for _,equipment in pairs(currentGuiEntity.grid.equipment) do
		if equipment.name==trainWhistleEquipment then
			return
		end
	end
	if global.trains[currentGuiEntity.train.id] then
		global.trains[currentGuiEntity.train.id]=nil
	end
end