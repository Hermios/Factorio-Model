Connector={}
StraightRail={}
CurvedRail={}
trainEntity={}
eventsControl["rail-signal"]=Connector
eventsControl["electric-pole"]=Connector
eventsControl["straight-rail"]=StraightRail
eventsControl["curved-rail"]=CurvedRail
eventsControl["locomotive"]=trainEntity

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
			listRails[railId]:connectCloserNodes(listRailPoleConnectors[railPoleConnector.entity.unit_number])
		end
	elseif entity.type=="electric-pole" then
		for _,neighbourTable in pairs(entity.neighbours ) do
			for _,neighbour in pairs(neighbourTable)do		
				if neighbour.name==circuitNode then
					entity.disconnect_neighbour(neighbour)
				end
			end
		end	
	end
end

Connector.OnRemoved=function(entity)
	if listRailPoleConnectors[entity.unit_number] then
		listRailPoleConnectors[entity.unit_number]:remove()
	end
end

StraightRail.OnBuilt=function(entity)
	if railType[entity.name]=="straight" then
		listRails[entity.unit_number]=RailPrototype:new(entity)		
		listRails[entity.unit_number]:connectToOtherRails()
	end
end

CurvedRail.OnBuilt=function(entity)
	if railType[entity.name]=="curved" then
		listRails[entity.unit_number]=RailPrototype:new(entity)		
		listRails[entity.unit_number]:connectToOtherRails()
	end
end

StraightRail.OnRemoved=function(entity)
	if railType[entity.name]=="straight" and listRails[entity.unit_number] then
		listRails[entity.unit_number]:remove()			
	end
end

CurvedRail.OnRemoved=function(entity)
	if railType[entity.name]=="curved" then
		listRails[entity.unit_number]:remove()			
	end
end

OnTrainCreated=function(event)
	listTrains[event.train.id]=TrainPrototype:new(event.train)
	if event.old_train_id_1 then listTrains[event.old_train_id_1]=nil end
	if event.old_train_id_2 then listTrains[event.old_train_id_2]=nil end
end

trainEntity.OnRemoved=function(entity)
	listTrains[entity.train.id]=nil
end