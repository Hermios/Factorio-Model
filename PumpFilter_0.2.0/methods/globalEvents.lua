pumpEntity={}
EventsControl["pump"]=pumpEntity
EventsControl["pump"].allowType=true
--Pump

pumpEntity.OnRemoved=function(entity)
	listPumps[entity.unit_number]=nil
end

pumpEntity.OnGuiOpened=function(entity)
	listPumps[entity.unit_number]=listPumps[entity.unit_number] or PumpPrototype:new(entity)
end