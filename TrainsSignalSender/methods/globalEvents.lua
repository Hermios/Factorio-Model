trainStopEntity={}
trainEntity={}
EventsControl["train-stop"]=trainStopEntity
EventsControl["locomotive"]=trainEntity
trainEntity.allowType=true

--On tick
OnTick=function()
	for id,_ in pairs(global.listTrainsAtStop) do 
		local trainData=listTrains[id]
		if trainData.globalData.entity and trainData.globalData.entity.valid and trainData.globalData.entity.station and trainData.globalData.entity.station.valid then
			local signals={}		
			for index,data in pairs((trainData.globalData.guiData or {}).signals or {}) do
				if (data.signal or {}).name then
					table.insert(signals,{signal=data.signal,count=trainData:getCalculatedCountForSignal(data),index=index})
				end
			end
			if listTrainsStop[trainData.globalData.entity.station.unit_number] then
				listTrainsStop[trainData.globalData.entity.station.unit_number]:setParameters(signals)
			end
		elseif not trainData.globalData.entity or not trainData.globalData.entity.valid then
			listTrains[id]=nil
			global.listTrainsAtStop[id]=nil
		end
	end
end

--Research
OnResearchFinished=function()
	for _,trainStop in pairs(game.surfaces[1].find_entities_filtered{type="train-stop"}) do
		TrainStopPrototype:new(trainStop)
	end
	for _,train in pairs(game.surfaces[1].get_trains()) do
		TrainPrototype:new(train)
	end
end

function OnTrainStateChanged(event)
	local train=event.train
	if not train or not train.valid then
		return
	end
	if not listTrains[train.id] then
		TrainPrototype:new(train)
	end
	if listTrains[train.id].station and not train.station then
		if listTrains[train.id].station.valid then listTrainsStop[listTrains[train.id].globalData.station.unit_number]:setParameters() end
		listTrains[train.id].station=nil
		global.listTrainsAtStop[train.id]=nil
	elseif train.station and not listTrains[train.id].station then
		listTrains[train.id].globalData.station=train.station
		global.listTrainsAtStop[train.id]=true
	end
end

OnTrainCreated=function(event)
	local newTrain=TrainPrototype:new(event.train)
--if no previous train
	if not event.old_train_id_1 or not listTrains[event.old_train_id_1] then
		return
	end

--if at least one previous train
	newTrain.globalData.station=listTrains[event.old_train_id_1].globalData.station
	newTrain.globalData.guiData=listTrains[event.old_train_id_1].globalData.guiData
	listTrains[event.old_train_id_1]=nil
	global.listTrains[event.old_train_id_1]=nil
	global.listTrainsAtStop[event.old_train_id_1]=nil
	
-- if both previous trains, add a second
	if event.old_train_id_2 and listTrains[event.old_train_id_2] then
		for _,d in pairs(listTrains[event.old_train_id_2].globalData.guiData.signals or {}) do		
			index=#listTrains[event.train.id].globalData.guiData.signals
			listTrains[event.train.id].globalData.guiData.signals[tostring(index)]={signal=d.signal,count=d.count,index=index+1}
		end
		listTrains[event.old_train_id_2]=nil 
		global.listTrains[event.old_train_id_2]=nil 
		global.listTrainsAtStop[event.old_train_id_2]=nil
	end
end

trainEntity.OnRemoved=function(entity)
	if (#entity.train.locomotives.front_movers + #entity.train.locomotives.back_movers)==0 then
		listTrains[entity.train.id]=nil
		global.listTrains[entity.train.id]=nil
		global.listTrainsAtStop[entity.train.id]=nil
	end
end

trainStopEntity.OnBuilt=function(entity)
	TrainStopPrototype:new(entity)
end

trainStopEntity.OnRemoved=function(entity)	
	listTrainsStop[entity.unit_number]:removeTrainStop()
end