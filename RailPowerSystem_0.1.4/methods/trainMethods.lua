local trains={}
local previousAccuTable={}
entities[hybridTrain]=trains
local trainPreviousAccu={}
trains.onTick=function (entity)
	local rail=entity.train.front_rail or entity.train.back_rail
	if not entities[rail.name] then
		return
	end
	basePowerMax=5000
	--reset previous accu passed from train, so it doesn't drain useless energy
	if previousAccuTable[entity.unit_number ] and previousAccuTable[entity.unit_number ].valid then
		previousAccuTable[entity.unit_number ].electric_drain=0
		previousAccuTable[entity.unit_number ]=nil
	end
	
	local requiredPower=basePowerMax-entity.energy
	if requiredPower<=0 then
		return
	end
	local ghostAccu=ghostRailAccu(rail)
	ghostAccu.electric_drain = requiredPower
	local max_power = ghostAccu.energy
	local power_transfer = 0
	if (max_power < requiredPower) then
		power_transfer = max_power
	else
		power_transfer = requiredPower
	end
	  
	--  Transfer energy that will be drained over the next second into some entity
	entity.energy = entity.energy + power_transfer
	ghostAccu.energy=ghostAccu.energy-power_transfer
	previousAccuTable[entity.unit_number ]=ghostAccu	  
end

trains.onBuilt=function(entity)	
	global.electricTrains[entity.unit_number]=entity
end

trains.onRemove=function(entity)
	global.electricTrains[entity.unit_number]=nil
end