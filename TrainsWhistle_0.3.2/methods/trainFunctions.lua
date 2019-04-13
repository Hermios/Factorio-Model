TrainPrototype={}

function TrainPrototype:new(entity,data)
	if entity.valid==false then
		return
	end
	local o = data or
	{
		globalData=
		{
			entity=entity,
			conditions={{type="inactivity",ticks=180,compare_type="and"}}
		}
	}  
	setmetatable(o, self)
	if o:hasEquipment(trainWhistleEquipment) then
		listTrains[entity.id]=o
		global.listTrains[entity.id]=o.globalData
		return o
	else
		return nil
	end
end

function TrainPrototype:hasEquipment(equipment)
	if not (self.globalData.entity or {}).valid then
		return false
	end
	for _,loco in pairs(self.globalData.entity.locomotives.front_movers) do
		if loco.grid.get_contents()[equipment] then
			return true
		end
	end
	for _,loco in pairs(self.globalData.entity.locomotives.back_movers) do
		if loco.grid.get_contents()[equipment] then
			return true
		end
	end
end

function TrainPrototype:addStation(station,targetId)
	if not (self.globalData.entity or {}).valid then
		return
	end
	local schedule=self.globalData.entity.schedule or {current=1,records={}}
	table.insert(schedule.records,{station=station.backer_name,wait_conditions=self.globalData.conditions})
	schedule.current=#schedule.records
	self.globalData.entity.schedule=schedule
	self.globalData.targetId=targetId
	local previousMode=self.globalData.entity.manual_mode
	self.globalData.entity.manual_mode=false
	--if no path
	if self.globalData.entity.has_path==false then
		self:releaseTrain(station,previousMode)
		return false
	else
		return true
	end
end

function TrainPrototype:isFree()
	if not (self.globalData.entity or {}).valid then
		return false
	end
-- if a station is defined, the train is already called
	if self.globalData.targetId then return false end
	--Check if there is a driver
	for _,loco in pairs(self.globalData.entity.locomotives.front_movers) do
		if loco.get_driver() then
			return false
		end	
	end
	for _,loco in pairs(self.globalData.entity.locomotives.back_movers) do
		if loco.get_driver() then
			return false
		end
	end
	return true
end

function TrainPrototype:releaseTrain(station,previousMode)
	if not (self.globalData.entity or {}).valid then
		return
	end
	
	local station=(station or listTrainStops[self.globalData.targetId].globalData.station or {})
	if not station or not station.valid then return end
	local schedule=self.globalData.entity.schedule or {current=1,records={}}
	for index,record in pairs(schedule.records) do
		if record.station==station.backer_name then
			table.remove(schedule.records,index)
		end
	end
	if schedule.current>#schedule.records then
		schedule.current=1
	end
	self.globalData.entity.schedule=schedule
	self.globalData.targetId=nil
	self.globalData.entity.manual_mode=previousMode or true
	station.destroy()
end