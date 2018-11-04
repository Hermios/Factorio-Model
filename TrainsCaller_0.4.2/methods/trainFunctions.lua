TrainPrototype={}

function TrainPrototype:new (entity,sourceData)
	if entity.valid==false then
		return false
	end
	local o=sourceData or 
	{
		entity=entity,
		queue={},
		allowMultipleCalls=true,
		conditions={{type="inactivity",ticks=180,compare_type="and"}}
	}
	setmetatable(o, self)
    self.__index = self
	return o
end

function setListTrains(train,sourceData)
	if train.valid==false then
		return false
	end
	for _,loco in pairs(train.locomotives.front_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				listTrains[train.id]=TrainPrototype:new(train,sourceData)
				return
			end
		end
	end
	for _,loco in pairs(train.locomotives.back_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				listTrains[train.id]=TrainPrototype:new(train,sourceData)
				return
			end
		end
	end
	listTrains[train.id]=nil
end

function TrainPrototype:hasSignal(signalId)
	if self.entity.valid==false then
		return false
	end
--search in cargos			
	if signalId.type=="item" and self.entity.get_contents()[signalId.name] then
		return true
	elseif signalId.type=="fluid" and  self.entity.get_fluid_contents()[signalId.name] then		
		return true
	end
	if game.active_mods["TrainsSignalSender"] then
		return remote.call("TrainsSignalSender","hasSignal",self.entity,signalId)
	end
	return false
end

function TrainPrototype:isCallable()
	if self.entity.valid==false then
		return false
	end
	return self.allowMultipleCalls==true or #self.queue==0
end

function TrainPrototype:addTrainStop(trainStop)
	if self.entity.valid==false then
		return
	end
--if the trainStop has alreaddy the train(we can reasonably assume that the train has the trainStop)
	if trainStop.signalsPerTrain[self.entity.id] then
		return
	end
	local trainStop_BackerName=trainStop.entity.backer_name
	table.insert(self.queue,{name=trainStop_BackerName,isCurrent=false})
--if only one item in the queue or multiple calls available, add it to the GUI
	if #self.queue==1 or self.allowMultipleCalls==true then
		self:addTrainStopToGui(#self.queue)
	end
end

function TrainPrototype:addTrainStopToGui(queueIndex)
	if self.entity.valid==false then
		return
	end
	local backer_name=self.queue[queueIndex].name
	self.queue[queueIndex].isCurrent=true
	local schedule=self.entity.schedule or {current=1,records={}}
	table.insert(schedule.records,{station=backer_name,wait_conditions=self.conditions})
	self.entity.schedule=schedule
end

function TrainPrototype:removeTrainStop(trainStop)
	local backer_name=trainStop.entity.backer_name
	local isCurrent=false
	for index,queueData in pairs(self.queue) do
		if queueData.name==backer_name then
			isCurrent=queueData.isCurrent or isCurrent
			table.remove(self.queue,index)
		end
	end
	if self.entity.valid==false then
		return
	end
	local schedule=self.entity.schedule or {current=1,records={}}
	for index,record in pairs(schedule.records) do
		if record.station==backer_name then
			table.remove(schedule.records,index)
		end
	end
	if schedule.current>#schedule.records then
		schedule.current=1
	end
	self.entity.schedule=schedule
	local previousMode=self.entity.manual_mode
	self.entity.manual_mode=true
	self.entity.manual_mode=previousMode
	for index,queueData in pairs(self.queue) do
		if queueData.isCurrent==false then
			self:addTrainStopToGui(index)
			return
		end
	end
end
