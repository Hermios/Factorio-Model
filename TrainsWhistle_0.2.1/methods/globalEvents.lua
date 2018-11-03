listCustomEvents={}

trainWhistleEquip={}
eventsControl[trainWhistleEquipment]=trainWhistleEquip

OnTrainStateChanged=function(event)
	if (listTrains[event.train.id] or {}).targetId then
		if event.train.state==defines.train_state.path_lost then
			player.print({"PATH_LOST"})
			local targetId=listTrains[event.train.id].targetId
			listTrains[event.train.id]:releaseTrain()
			local trainStopProto=listTrainStops[targetId]
			while index<=#trainStopProto.positions and trainStopProto:findTrain(index) do
				index=index+1
			end
		end
		if index>#trainStopProto.positions then
			player.print({"NO_TRAIN"})
			listTrainStops[targetId]=nil
		end
	elseif event.train.state==defines.train_state.wait_station and listTrainStops[listTrains[event.train.id].targetId].station==event.train.station then
		listTrainStops[listTrains[event.train.id].targetId]:remove()
		listTrains[event.train.id]:releaseTrain()
	end
end

OnTrainCreated=function(event)
	local newPrototype=TrainPrototype:new(event.train)
	if newPrototype:hasEquipment(trainWhistleEquipment) then
		listTrains[newPrototype.entity.id]=newPrototype
	end
	if event.old_train_id_1 and listTrains[event.old_train_id_1] and listTrains[event.old_train_id_1]:hasEquipment(trainWhistleEquipment)==false
	then
		listTrains[event.old_train_id_1]=nil
	end
	if event.old_train_id_2 and listTrains[event.old_train_id_2] and listTrains[event.old_train_id_2]:hasEquipment(trainWhistleEquipment)==false
	then
		listTrains[event.old_train_id_2]=nil
	end
end

OnTrainWhistled=function()
	local entity=player.selected
	if entity.type=="straight-rail" then
		local trainStopProto=TrainStopPrototype:new(entity)
		local index=1
		while index<=#trainStopProto.positions and trainStopProto:findTrain(index) do
			index=index+1
		end
		if index>#trainStopProto.positions then
			player.print({"NO_TRAIN"})
		else
			listTrainStops[entity.unit_number]=trainStopProto
		end
	end
end

trainWhistleEquip.OnEquipmentPlaced=function(event)
	local entity=player.opened
	if (entity or {}).type=="locomotive" then
		listTrains[entity.train.id]=listTrains[entity.train.id] or TrainPrototype:new(entity.train)	
	end
end

trainWhistleEquip.OnEquipmentRemoved=function(event)
	local entity=player.opened
	if listTrains[(((entity or {}).train) or {}).id or ""] and
		not listTrains[entity.train.id]:hasEquipment(event.equipment.name)then
		listTrains[entity.train.id]=nil
	end
end