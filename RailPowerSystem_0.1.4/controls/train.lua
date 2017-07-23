local basePowerMax = 10666.6666666666666666666667
local trains={}
local previousAccuTable={}
entities[hybridTrain]=trains
local trainPreviousAccu={}
trains.onInit=function()
	global.basePowerMax = game.entity_prototypes["hybrid-train"].max_energy_usage + 10;
	basePowerMax = global.basePowerMax;
end
trains.onLoad=function()
	basePowerMax = global.basePowerMax;
end
trains.onConfigurationChanged=function()
	global.basePowerMax = game.entity_prototypes["hybrid-train"].max_energy_usage + 10;
	basePowerMax = global.basePowerMax;
end
trains.onTick=function (entity)
	local rail=entity.train.front_rail or entity.train.back_rail
	if not string.ends(rail.name,"power") then
		return
	end
	--reset previous accu passed from train, so it doesn't drain useless energy
	if previousAccuTable[entity.unit_number ] and previousAccuTable[entity.unit_number ].valid then
		previousAccuTable[entity.unit_number ].electric_drain=0
		previousAccuTable[entity.unit_number ]=nil
	end
	
	local requiredPower=basePowerMax-entity.energy
	local ghostAccu=ghostRailAccu(rail)
	ghostAccu.electric_drain = requiredPower/60
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