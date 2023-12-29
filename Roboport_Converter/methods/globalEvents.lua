roboportEntity={}
EventsControl["roboport"]=roboportEntity
roboportEntity.allowType=true

roboportEntity.OnGuiOpened=function(entity)
	if not listRoboport[entity.unit_number]  then
		RoboportPrototype:new(entity)
	end
end

OnTick=function()
	for _,robotData in pairs(listRoboport) do
		robotData:setSignals()
	end
end

roboportEntity.OnBuilt=function(entity)
	RoboportPrototype:new(entity)
end

roboportEntity.OnRemoved=function(entity)
	if listRoboport[entity.unit_number] then
		listRoboport[entity.unit_number]:removeRoboport()
	end
end