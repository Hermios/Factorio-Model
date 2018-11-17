PumpPrototype={}

function PumpPrototype:new (entity,sourceData)
	if entity.valid==false then
		return nil
	end
	local o=sourceData or 
	{
		entity=entity,
		filteringFluidName="",
		
	}
	setmetatable(o, self)
    self.__index = self
	return o
end