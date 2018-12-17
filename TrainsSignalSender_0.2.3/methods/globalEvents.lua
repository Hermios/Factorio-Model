trainStopEntity={}
trainEntity={}
eventsControl["train-stop"]=trainStopEntity
eventsControl["locomotive"]=trainEntity

--On tick
OnTick=function()
	for id,trainData in pairs(global.listTrainsAtStop) do 
		if trainData.entity and trainData.entity.valid and trainData.entity.station and trainData.entity.station.valid then
			local signals={}		
			for index,data in pairs(trainData.signals) do
				if data.signal.name then
					table.insert(signals,{signal=data.signal,count=trainData:getCalculatedCountForSignal(data),index=index})
				end
			end
			if listTrainsStop[trainData.entity.station.unit_number] then
				listTrainsStop[trainData.entity.station.unit_number]:setParameters(signals)
			end
		elseif not trainData.entity or not trainData.entity.valid then
			listTrains[id]=nil
			global.listTrainsAtStop[id]=nil
		end
	end
end

--Research
OnResearchFinished=function()
	for _,trainStop in pairs(game.surfaces[1].find_entities_filtered{type="train-stop"}) do
		listTrainsStop[trainStop.unit_number]=TrainStopPrototype:new(trainStop)
	end
	for _,train in pairs(game.surfaces[1].get_trains()) do
		listTrains[train.id]=TrainPrototype:new(train)
	end
end

function OnTrainStateChanged(event)
	local train=event.train
	if not train or not train.valid then
		return
	end
	if not listTrains[train.id] then
		listTrains[train.id]=TrainPrototype:new(train)
	end
	if listTrains[train.id].station and not train.station then
		if listTrains[train.id].station.valid then listTrainsStop[listTrains[train.id].station.unit_number]:setParameters() end
		listTrains[train.id].station=nil
		global.listTrainsAtStop[train.id]=nil
	elseif train.station and not listTrains[train.id].station then
		listTrains[train.id].station=train.station
		global.listTrainsAtStop[train.id]=listTrains[train.id]
	end
end

OnTrainCreated=function(event)
--if no previous train
	if not event.old_train_id_1 and not event.old_train_id_2 then
		listTrains[event.train.id]=TrainPrototype:new(event.train)
		return
	end

--if at least one previous train
	local firstOldTrain=event.old_train_id_1
	GuiEntities["locomotive"]:closeGui()
	listTrains[event.train.id]=TrainPrototype:new(event.train,listTrains[firstOldTrain])
	listTrains[firstOldTrain]=nil
	global.listTrainsAtStop[firstOldTrain]=nil
-- if both previous trains, add a second
	if event.old_train_id_1 and event.old_train_id_2 and listTrains[event.old_train_id_2] then
		for i,d in pairs(listTrains[event.old_train_id_2].signals) do
				table.insert(listTrains[event.train.id].signals,{signal=d.signal,count=d.count,index=#listTrains[event.train.id].signals})
		end
		listTrains[event.old_train_id_2]=nil 
		global.listTrainsAtStop[event.old_train_id_2]=nil
	end	
end

trainEntity.OnRemoved=function(entity)
	if (#entity.train.locomotives.front_movers + #entity.train.locomotives.back_movers)==1 then
		listTrains[entity.train.id]=nil
		global.listTrainsAtStop[entity.train.id]=nil
	end
end

trainStopEntity.OnBuilt=function(entity)
	listTrainsStop[entity.unit_number]=TrainStopPrototype:new(entity)
end

trainStopEntity.OnRemoved=function(entity)	
	listTrainsStop[entity.unit_number]:removeTrainStop()
end