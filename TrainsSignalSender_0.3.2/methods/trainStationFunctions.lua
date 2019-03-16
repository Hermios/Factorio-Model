TrainStopPrototype={}

function TrainStopPrototype:new(entity)
	if entity.valid==false then
		return
	end
	local sender = entity.surface.create_entity({name="ghost-constant-combinator",position=entity.position,force=entity.force})
		sender.operable = false
		sender.minable = false
		sender.destructible = false
		entity.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
		entity.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
	local o =
	{
	globalData=
		{
			entity=entity,
			sender=sender
		}
	} 
	setmetatable(o, self)
	global.listTrainsStop[entity.unit_number]=o.globalData
	listTrainsStop[entity.unit_number]=o
	return o
end

function TrainStopPrototype:setParameters(signals)
	self.globalData.sender.get_or_create_control_behavior().parameters={ parameters=signals or {} }
end

function TrainStopPrototype:removeTrainStop()
	self.globalData.sender.destroy()
	global.listTrainsStop[self.globalData.entity.unit_number]=nil
	listTrainsStop[self.globalData.entity.unit_number]=nil
end