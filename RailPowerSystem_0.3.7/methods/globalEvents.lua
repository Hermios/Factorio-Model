connectorEntity={}
railEntity={}
trainEntity={}
EventsControl[prototypeConnector]=connectorEntity
EventsControl[railPoleConnector]=connectorEntity
EventsControl["straight-rail"]=railEntity
EventsControl["curved-rail"]=railEntity
EventsControl["locomotive"]=trainEntity
connectorEntity.allowType=true
railEntity.allowType=true
trainEntity.allowType=true

function OnTick()
	for _,data in pairs(listTrains) do
		data:update()
	end
end

connectorEntity.OnBuilt=function(entity)	
	RailPoleConnectorPrototype:new(entity):connectToRail()
end

connectorEntity.OnRemoved=function(entity)	
	listRailPoleConnectors[entity.unit_number]=nil
end

railEntity.OnBuilt=function(entity)
	if railType[entity.name] then
		RailPrototype:new(entity):connectToOtherRails()			
	end
end

railEntity.OnRemoved=function(entity)
	if listRails[entity.unit_number] then
		listRails[entity.unit_number]:remove()			
	end
end

OnTrainCreated=function(event)
	if event.old_train_id_1 then listTrains[event.old_train_id_1]=nil end
	if event.old_train_id_2 then listTrains[event.old_train_id_2]=nil end
	for _,loco in pairs(event.train.locomotives.front_movers) do
		if locomotiveType[loco.name] then
			TrainPrototype:new(event.train)	
			return
		end
	end
	for _,loco in pairs(event.train.locomotives.back_movers) do
		if locomotiveType[loco.name] then
			TrainPrototype:new(event.train)	
			return
		end
	end
end

trainEntity.OnRemoved=function(entity)
	listTrains[entity.train.id]=nil
end