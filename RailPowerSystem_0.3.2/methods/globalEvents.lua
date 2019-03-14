Connector={}
StraightRail={}
CurvedRail={}
trainEntity={}
EventsControl["rail-signal"]=Connector
EventsControl["electric-pole"]=Connector
EventsControl["straight-rail"]=StraightRail
EventsControl["curved-rail"]=CurvedRail
EventsControl["locomotive"]=trainEntity
Connector.allowType=true
StraightRail.allowType=true
CurvedRail.allowType=true
trainEntity.allowType=true

function OnTick()
	for _,data in pairs(listTrains) do
		data:update()
	end
end

Connector.OnBuilt=function(entity)	
	if entity.name==prototypeConnector then
		local railPoleConnector=RailPoleConnectorPrototype:new(entity)
		local railId=railPoleConnector:getConnectedRailId()
		if listRails[railId] then
			listRails[railId]:connectCloserNodes(railPoleConnector)
		end
	elseif entity.type=="electric-pole" then
		for _,neighbourTable in pairs(entity.neighbours) do
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
	if event.old_train_id_1 then listTrains[event.old_train_id_1]=nil end
	if event.old_train_id_2 then listTrains[event.old_train_id_2]=nil end
	for _,loco in pairs(event.train.locomotives.front_movers) do
		if locomotiveType[loco.name]=="electric" then
			TrainPrototype:new(event.train)	
			return
		end
	end
	for _,loco in pairs(event.train.locomotives.back_movers) do
		if locomotiveType[loco.name]=="electric" then
			TrainPrototype:new(event.train)	
			return
		end
	end
end

trainEntity.OnRemoved=function(entity)
	listTrains[entity.train.id]=nil
end