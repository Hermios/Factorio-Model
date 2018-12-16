TrainStopPrototype={}

function TrainStopPrototype:new(entity,data)
	if entity.valid==false then
		return
	end
	local sender=(data or {}).sender
	if not sender then
		sender = entity.surface.create_entity({name="ghost-constant-combinator",position=entity.position,force=entity.force})
		sender.operable = false
		sender.minable = false
		sender.destructible = false
		entity.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
		entity.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
	end
	local o = data or
	{
		entity=entity,
		sender=sender,
		setDifference=false
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function TrainStopPrototype:setParameters(signals)
	self.sender.get_or_create_control_behavior().parameters={ parameters=signals or {} }
end

function TrainStopPrototype:removeTrainStop()
	listTrainsStop[self.entity.unit_number].sender.destroy()
	listTrainsStop[self.entity.unit_number]=nil
end