TrainPrototype={}
locomotiveType={}
locomotiveType[hybridTrain]="electric"

function TrainPrototype:new(entity)
	if entity.valid==false then
		return nil
	end
	local o=
	{
		globalData=
		{
			entity=entity
		}
	}   
	setmetatable(o, self)
	listTrains[entity.id]=o
	global.listTrains[entity.id]=o.globalData
	return o
end

local function updateLocoPower(self,locomotive)
	local requiredPower=locomotive.prototype.max_energy_usage-locomotive.energy
	local rail=self.globalData.entity.front_rail or self.globalData.entity.back_rail
	if not rail or not listRails[rail.unit_number] then
		return
	end
	local railData=listRails[rail.unit_number].globalData
	if locomotive.valid==true and requiredPower>0 and railData and locomotiveType[locomotive.name] then		
		local max_power = railData.accu.energy
		local power_transfer = 0
		if (max_power < requiredPower) then
			power_transfer = max_power
		else
			power_transfer = requiredPower
		end

		--  Transfer energy that will be drained over the next tick into some entity
		locomotive.energy = locomotive.energy + power_transfer
		railData.accu.energy=railData.accu.energy-power_transfer 
	end
end

function TrainPrototype:update()
	if self.globalData.entity.valid==false then
		return
	end
	for _,locomotive in pairs(self.globalData.entity.locomotives["front_movers"]) do
		updateLocoPower(self,locomotive)
	end
	for _,locomotive in pairs(self.globalData.entity.locomotives["back_movers"]) do
		updateLocoPower(self,locomotive)
	end
end