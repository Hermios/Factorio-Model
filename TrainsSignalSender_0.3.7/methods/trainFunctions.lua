TrainPrototype={}

function TrainPrototype:new(entity)
	if entity.valid==false then
		return
	end
	local o= 
	{
		globalData={
			entity=entity,
			station=entity.station,
			guiData={signals={}}
		}
	}
	setmetatable(o, self)
	global.listTrains[getUnitId(entity)]=o.globalData
	listTrains[getUnitId(entity)]=o
	return o
end

function TrainPrototype:getCalculatedCountForSignal(signalData)
	local train=self.globalData.entity
	local i=0	
	if not train.valid or not train.station or not train.station.valid then
		return 1
	end	
	local setDifference=(listTrainsStop[train.station.unit_number].globalData.guiData or {}).setDifference or false
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