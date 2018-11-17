roboportEntity={}
eventsControl["roboport"]=roboportEntity

InitData=function()
	for _,roboport in pairs(game.surfaces[1].find_entities_filtered{type="roboport"}) do
		listRoboport[roboport.unit_number]=listRoboport[roboport.unit_number] or RoboportPrototype:new(roboport)
	end
end

OnTick=function()
	for _,data in pairs(listRoboport) do
		data:setSignals()
	end
end

roboportEntity.OnBuilt=function(entity)
	listRoboport[entity.unit_number]=RoboportPrototype:new(entity)
end

roboportEntity.OnRemoved=function(entity)
	if listRoboport[entity.unit_number] then
		listRoboport[entity.unit_number]:removeRoboport()
	end
end