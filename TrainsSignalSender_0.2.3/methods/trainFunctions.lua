TrainPrototype={}

function TrainPrototype:new(entity, sourceData)
	if entity.valid==false and not sourceData then
		return
	end
	local o=sourceData or 
	{
		entity=entity,
		signals={},
		station=entity.station	
	}
	o.entity=entity
	setmetatable(o, self)
    self.__index = self	
	return o
end

function TrainPrototype:getCalculatedCountForSignal(signalData)
	local train=self.entity
	local i=0	
	if not train.valid or not train.station or not train.station.valid then
		return 1
	end
	local setDifference=listTrainsStop[train.station.unit_number].setDifference
	if setDifference==false or signalData.signal.type=="virtual" then
		return signalData.count
	else
		local trainQuantity
		if signalData.signal.type=="item" then
			trainQuantity=train.get_item_count(signalData.signal.name)
		elseif signalData.signal.type=="fluid" then
			trainQuantity=get_fluid_count(signalData.signal.name)
		end
		if train.station.get_control_behavior().read_from_train then
			return signalData.count-2*trainQuantity
		else
			return signalData.count-trainQuantity
		end
	end
end