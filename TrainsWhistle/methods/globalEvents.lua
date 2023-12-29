trainWhistleEquip={}
trainEntity={}
EventsControl[trainWhistleEquipment]=trainWhistleEquip
EventsControl["locomotive"]=trainEntity
trainEntity.allowType=true

OnTrainStateChanged=function(event)
	if (((listTrains[event.train.id] or {}).globalData) or {}).targetId then
		local targetId=listTrains[event.train.id].globalData.targetId
		if event.train.state==defines.train_state.path_lost then
			game.players[1].print({"PATH_LOST"})
			listTrains[event.train.id]:releaseTrain()
			local trainStopProto=listTrainStops[targetId].globalData
			trainStopProto.station.destroy()
			local index=1
			while index<=#trainStopProto.positions and trainStopProto:findTrain(index) do
				index=index+1
			end
			if index>#trainStopProto.positions then
				game.players[1].print({"NO_TRAIN"})
				listTrainStops[targetId]:remove()
			end
		elseif event.train.state==defines.train_state.wait_station and listTrainStops[targetId].globalData.station==event.train.station then
			listTrains[event.train.id]:releaseTrain()
			listTrainStops[targetId]:remove()
		end
	end
end

OnTrainCreated=function(event)
	local newPrototype=TrainPrototype:new(event.train)
	if event.old_train_id_1 and listTrains[event.old_train_id_1] and listTrains[event.old_train_id_1]:hasEquipment(trainWhistleEquipment)==false then
		listTrains[event.old_train_id_1]=nil
	end
	if event.old_train_id_2 and listTrains[event.old_train_id_2] and listTrains[event.old_train_id_2]:hasEquipment(trainWhistleEquipment)==false then
		listTrains[event.old_train_id_2]=nil
	end
end

OnTrainWhistled=function()
	local entity=game.players[1].selected
	if entity.type=="straight-rail" then
		local trainStopProto=TrainStopPrototype:new(entity)
		local index=1
			while index<=#trainStopProto.globalData.positions and not trainStopProto:findTrain(index) do
			index=index+1
		end
		if index>#trainStopProto.globalData.positions then
			game.players[1].print({"NO_TRAIN"})
			trainStopProto:remove()
		end
	end
end

function trainEntity.OnRemoved(entity)
	global.listTrains[entity.train.id]=nil
	listTrains[entity.train.id]=nil
end

trainWhistleEquip.OnEquipmentPlaced=function(event)
	local entity=game.players[1].opened
	if (entity or {}).type=="locomotive" and not listTrains[entity.train.id] then
		TrainPrototype:new(entity.train)	
	end
end

trainWhistleEquip.OnEquipmentRemoved=function(event)
	local entity=game.players[1].opened
	if listTrains[(((entity or {}).train) or {}).id or ""] and
		not listTrains[entity.train.id]:hasEquipment(event.equipment.name)then
		global.listTrains[entity.train.id]=nil
		listTrains[entity.train.id]=nil
	end
end