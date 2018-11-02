eventsControl={}

trainCallerEquip={}
trainStopEntity={}
trainEntity={}
eventsControl[trainCallerEquipment]=trainCallerEquip
eventsControl["train-stop"]=trainStopEntity
eventsControl["locomotive"]=trainEntity

--Research
OnResearchFinished=function()
	for _,trainStop in pairs(game.surfaces[1].find_entities_filtered{type="train-stop"}) do
		listTrainsStop[entity.unit_number]=TrainStopPrototype:new(trainStop)
	end
end

--Tick
function OnTick()	
	for _,trainStop in pairs(listTrainsStop) do
		trainStop:updateRequestedSignals()
	end
end

--Train Stop
trainStopEntity.OnBuilt=function(entity)
	listTrainsStop[entity.unit_number]=TrainStopPrototype:new(entity)
end

trainStopEntity.OnRemoved=function(entity)
	if listTrainsStop[entity.unit_number] then
		listTrainsStop[entity.unit_number]:removeFromTrainStopList()
	end
end

--Train
OnTrainCreated=function(event)
	if event.old_train_id_2 then
		setListTrains(event.train,listTrains[event.old_train_id_2])
		listTrains[event.old_train_id_2]=nil
	end
	if event.old_train_id_1 and listTrains[event.old_train_id_1] then
		setListTrains(event.train,listTrains[event.old_train_id_1])
		listTrains[event.old_train_id_1]=nil 
	else
		setListTrains(event.train)
	end
end

--Equipment
trainCallerEquip.OnEquipmentPlaced=function(event)
	local train=player.opened.train
	if train then
		setListTrains(train)
	end	
end

trainCallerEquip.OnEquipmentRemoved=function(event)
	local train=player.opened.train
	if train then
		setListTrains(train)
	end
end

