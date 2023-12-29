TACEvent={}
EventsControl[TACPrototype]=TACEvent
EventsControl[InputTAC]=TACEvent
OnTick=function()
	for id,tac in pairs(listTAC) do
		if tac.globalData.entity and tac.globalData.entity.valid then
			tac:processRules()
		else 
			listTAC[id]=nil
		end
	end
end

TACEvent.OnBuilt=function(entity)
	TACEntity:new(entity)
end

TACEvent.OnRemoved=function(entity)
	if listTAC[entity.unit_number] then
		listTAC[entity.unit_number]:remove(entity)
	end
end