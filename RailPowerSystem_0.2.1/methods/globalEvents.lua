eventsControl={}

Connector={}
StraightRail={}
CurvedRail={}

eventsControl["rail-signal"]=Connector
eventsControl["straight-rail"]=StraightRail
eventsControl["curved-rail"]=CurvedRail

function OnTick()
	for _,data in pairs(listTrains) do
		data:update()
	end
end

Connector.OnBuilt=function(entity)	
	if entity.name==prototypeConnector then
		local railPoleConnector=RailPoleConnectorPrototype:new(entity)
		listRailPoleConnectors[railPoleConnector.entity.unit_number]=railPoleConnector
		local railId=listRailPoleConnectors[railPoleConnector.entity.unit_number]:getConnectedRailId()
		if listRails[railId] then
		player.print("X")
			listRails[railId]:connectCloserNodes(listRailPoleConnectors[railPoleConnector.entity.unit_number])
		end
	end
end

Connector.OnRemove=function(entity)
	listRailPoleConnectors[entity.unit_number]:remove()
end

StraightRail.OnBuilt=function(entity)
	if railType[entity.name]=="straight" then
		listRails[entity.unit_number]=RailPrototype:new(entity)		
		listRails[entity.unit_number]:connectToOtherRails()
	end
end

StraightRail.OnRemove=function(entity)
	if railType[entity.name]=="straight" then
		listRails[entity.unit_number]:remove()			
	end
end

StraightRail.OnBuilt=function(entity)
	if railType[entity.name]=="curved" then
		listRails[entity.unit_number]=RailPrototype:new(entity)		
		listRails[entity.unit_number]:connectToOtherRails()
	end
end

StraightRail.OnRemove=function(entity)
	if railType[entity.name]=="curved" then
		listRails[entity.unit_number]:remove()			
	end
end

OnTrainCreated=function(event)
	listTrains[event.train.id]=TrainPrototype:new(event.train)
	if event.old_train_id_1 then listTrains[event.old_train_id_1]=nil end
	if event.old_train_id_2 then listTrains[event.old_train_id_2]=nil end
end