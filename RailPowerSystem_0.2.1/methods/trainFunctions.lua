TrainPrototype={}
locomotiveType={}

function TrainPrototype:new(entity,data)
	if entity.valid==false then
		return false
	end
	local o = data or
	{
		entity=entity
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function TrainPrototype:update()
	if self.entity.valid==false then
		return
	end
	for _,locomotive in pairs(self.entity.locomotives["front_movers"]) do
		local requiredPower=locomotive.prototype.max_energy_usage-locomotive.energy
		local railData=listRails[(self.entity.front_rail or self.entity.back_rail	or {}).unit_number]
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
end
