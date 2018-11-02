TrainStopPrototype={}

function TrainStopPrototype:new(trainStop,data)
	if trainStop.valid==false then
		return false
	end
	local sender=(data or {}).sender
	if not sender then
		sender = trainStop.surface.create_entity({name="ghost-constant-combinator",position=trainStop.position,force=trainStop.force})
		sender.operable = false
		sender.minable = false
		sender.destructible = false
		trainStop.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
		trainStop.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
	end
	local o = data or
	{
		sender=sender
	}   
	o.entity=trainStop
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