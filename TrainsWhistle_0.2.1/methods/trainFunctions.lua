TrainPrototype={}

function TrainPrototype:new(entity,data)
	if entity.valid==false then
		return false
	end
	local o = data or
	{
		entity=entity,
		conditions={{type="inactivity",ticks=180,compare_type="and"}}
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function TrainPrototype:hasEquipment(equipment)
	for _,loco in pairs(self.entity.locomotives.front_movers) do
		if loco.grid.get_contents()[equipment] then
			return true
		end
	end
	for _,loco in pairs(self.entity.locomotives.back_movers) do
		if loco.grid.get_contents()[equipment] then
			return true
		end
	end
end

function TrainPrototype:addStation(station,targetId)
	if self.entity.valid==false then
		return nil
	end
	local schedule=self.entity.schedule or {current=1,records={}}
	table.insert(schedule.records,{station=station.backer_name,wait_conditions=self.conditions})
	schedule.current=#schedule.records
	self.entity.schedule=schedule
	self.targetId=targetId
	if not self.entity.has_path() then
		self:releaseTrain(station)
		return false
	else
		return true
	end
end

function TrainPrototype:isFree()
-- if a station is defined, the train is already called
	if self.targetId then return false end
	
	--Check if there is a driver
	for _,loco in pairs(self.entity.locomotives.front_movers) do
		if loco.get_driver() then
			return false
		end	
	end
	for _,loco in pairs(self.entity.locomotives.back_movers) do
		if loco.get_driver() then
			return true
		end
	end
end

function TrainPrototype:releaseTrain(station)
	local stationName=(station or listTrainStops[self.targetId].station or {}).backer_name
	if not stationName then return end
	local schedule=self.entity.schedule or {current=1,records={}}
	for index,record in pairs(schedule.records) do
		if record.station==self.station.backer_name then
			table.remove(schedule.records,index)
		end
	end
	if schedule.current>#schedule.records then
		schedule.current=1
	end
	self.entity.schedule=schedule
	self.targetId=nil
	self.entity.manual_mode=true
end