pumpEntity={}
eventsControl["pump"]=pumpEntity

--Pump
pumpEntity.OnBuilt=function(entity)
	listPumps[entity.unit_number]=PumpPrototype:new(entity)
end

pumpEntity.OnRemoved=function(entity)
	listPumps[entity.unit_number]=nil
end