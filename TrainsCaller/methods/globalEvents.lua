trainCallerEquip={}
trainStopEntity={}
trainEntity={}
EventsControl[trainCallerEquipment]=trainCallerEquip
EventsControl["train-stop"]=trainStopEntity
EventsControl["locomotive"]=trainEntity
trainEntity.allowType=true

--Research
OnResearchFinished=function()
	for _,trainStop in pairs(game.surfaces[1].find_entities_filtered{type="train-stop"}) do
		TrainStopPrototype:new(trainStop)
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
	if entity.name=="train-stop" then
		TrainStopPrototype:new(entity)
	end
end

trainStopEntity.OnRemoved=function(entity)
	if listTrainsStop[entity.unit_number] then
		listTrainsStop[entity.unit_number]:removeFromTrainStopList()
	end
end

--Train
OnTrainCreated=function(event)
	setListTrains(event.train)
	if not listTrains[event.train.id] then
		return
	end
	if event.old_train_id_2 and listTrains[event.old_train_id_2] then
		listTrains[event.train.id].globalData.guiData=clone(listTrains[event.old_train_id_2].globalData.guiData)
		listTrains[event.train.id].globalData.queue=clone(listTrains[event.old_train_id_2].globalData.queue)
		listTrains[event.old_train_id_2]=nil
		global.listTrains[event.old_train_id_2]=nil
	end
	if event.old_train_id_1 and listTrains[event.old_train_id_1] then
		listTrains[event.train.id].globalData.guiData=clone(listTrains[event.old_train_id_1].globalData.guiData)
		listTrains[event.train.id].globalData.queue=clone(listTrains[event.old_train_id_1].globalData.queue)
		listTrains[event.old_train_id_1]=nil 
		global.listTrains[event.old_train_id_1]=nil 
	end
end

trainEntity.OnRemoved=function(entity)
	listTrains[entity.train.id]=nil
	global.listTrains[entity.train.id]=nil
end
--Equipment
trainCallerEquip.OnEquipmentPlaced=function(event)
	setListTrains(game.players[1].opened.train)	
end

trainCallerEquip.OnEquipmentRemoved=function(event)
	setListTrains(game.players[1].opened.train)
end

