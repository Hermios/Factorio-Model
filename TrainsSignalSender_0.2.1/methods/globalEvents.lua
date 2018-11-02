eventsControl={}

trainStopEntity={}
eventsControl["train-stop"]=trainStopEntity

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
		listTrainsStop[listTrains[train.id].station.unit_number]:setParameters()
		listTrains[train.id].station=nil
	elseif train.station and not listTrains[train.id].station then
		listTrains[train.id].station=train.station
		local signals={}
		for index,data in pairs(listTrains[train.id].signals) do
			table.insert(signals,{signal=data.signal,count=1,index=index})
		end
		listTrainsStop[listTrains[train.id].station.unit_number]:setParameters(signals)
	end
end

OnTrainCreated=function(event)
--if no previous train
	if not event.old_train_id_1 and not event.old_train_id_2 then
		listTrains[event.train.id]=TrainPrototype:new(event.train)
		return
	end

--if at least one previous train
	local firstOldTrain=event.old_train_id_1 or event.old_train_id_2
	GuiEntities["locomotive"]:closeGui()
	if event.old_train_id_2 then
		listTrains[event.train.id]=TrainPrototype:new(event.train,listTrains[firstOldTrain])
		listTrains[firstOldTrain]=nil
	end
	
-- if both previous trains, add a second
	if event.old_train_id_1 and event.old_train_id_2 then
		for i,d in pairs(listTrains[event.old_train_id_2].signals) do
				table.insert(listTrains[event.train.id].signals,{signal=d.signal,count=d.count,index=#listTrains[event.train.id].signals})
		end
		listTrains[event.old_train_id_2]=nil 
	end
end

trainStopEntity.OnBuilt=function(entity)
	listTrainsStop[entity.unit_number]=TrainStopPrototype:new(entity)
end

trainStopEntity.OnRemoved=function(entity)	
	listTrainsStop[entity.unit_number]:removeTrainStop()
end