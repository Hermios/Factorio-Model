TrainPrototype={}

function TrainPrototype:new(entity, sourceData)
	if entity.valid==false then
		return
	end
	local o=sourceData or 
	{
		entity=entity,
		signals={},
		station=entity.station	
	}
	setmetatable(o, self)
    self.__index = self
	return o
end