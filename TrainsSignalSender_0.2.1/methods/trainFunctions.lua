TrainPrototype={}

function TrainPrototype:new(entity, sourceData)
	local o=sourceData or 
	{
		signals={},
		station=entity.station	
	}
    o.entity=entity
	setmetatable(o, self)
    self.__index = self
	return o
end