TrainPrototype={}

function TrainPrototype:new(entity)
	if entity.valid==false then
		return false
	end
	local o= 
	{
		globalData=
		{
			entity=entity,
			queue={},
			guiData={conditions={{type="inactivity",ticks=180,compare_type="and"}}}
		}
	}
	setmetatable(o, self)
	global.listTrains[getUnitId(entity)]=o.globalData
	listTrains[getUnitId(entity)]=o
	return o
end

function setListTrains(train)
	if not (train or {}).valid then
		return false
	end
	for _,loco in pairs(train.locomotives.front_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				TrainPrototype:new(train)
				return
			end
		end
	end
	for _,loco in pairs(train.locomotives.back_movers) do
		for _,equipment in pairs(loco.grid.equipment) do
			if equipment.name==trainCallerEquipment then
				TrainPrototype:new(train)
				return
			end
		end
	end
	listTrains[train.id]=nil
	global.listTrains[train.id]=nil
end

function TrainPrototype:hasSignal(signalId)
	if self.globalData.entity.valid==false then
		return false
	end
--search in cargos			
	if signalId.type=="item" and self.globalData.entity.get_contents()[signalId.name] then
		return true
	elseif signalId.type=="fluid" and  self.globalData.entity.get_fluid_contents()[signalId.name] then		
		return true
	end
	if game.active_mods["TrainsSignalSender"] then
		return remote.call("TrainsSignalSender","hasSignal",self.globalData.entity,signalId)
	end
	return false
end

function TrainPrototype:isCallable()
	if self.globalData.entity.valid==false then
		return false
	end
	return self.globalData.guiData.allowMultipleCalls==true or #self.globalData.queue==0
end

function TrainPrototype:addTrainStop(trainStop)
	if self.globalData.entity.valid==false then
		return
	end
--if the trainStop has alreaddy the train(we can reasonably assume that the train has the trainStop)
	if trainStop.globalData.signalsPerTrain[self.globalData.entity.id] then
		return
	end
	local trainStop_BackerName=trainStop.globalData.entity.backer_name
	table.insert(self.globalData.queue,{name=trainStop_BackerName,isCurrent=false})
--if only one item in the queue or multiple calls available, add it to the GUI
	if #self.globalData.queue==1 or self.globalData.guiData.allowMultipleCalls==true then
		self:addTrainStopToGui(#self.globalData.queue)
	end
end

function TrainPrototype:addTrainStopToGui(queueIndex)
	if self.globalData.entity.valid==false then
		return
	end
	local backer_name=self.globalData.queue[queueIndex].name
	self.globalData.queue[queueIndex].isCurrent=true
	local schedule=self.globalData.entity.schedule or {current=1,records={}}
	table.insert(schedule.records,{station=backer_name,wait_conditions=self.globalData.guiData.conditions})
	self.globalData.entity.schedule=schedule
end

function TrainPrototype:removeTrainStop(trainStop)
	local backer_name=trainStop.globalData.entity.backer_name
	local isCurrent=false
	for index,queueData in pairs(self.globalData.queue) do
		if queueData.name==backer_name then
			isCurrent=queueData.isCurrent or isCurrent
			table.remove(self.globalData.queue,index)
		end
	end
	if self.globalData.entity.valid==false then
		return
	end
	local schedule=self.globalData.entity.schedule or {current=1,records={}}
	for index,record in pairs(schedule.records) do
		if record.station==backer_name then
			table.remove(schedule.records,index)
		end
	end
	if schedule.current>#schedule.records then
		schedule.current=1
	end
	self.globalData.entity.schedule=schedule
	local previousMode=self.globalData.entity.manual_mode
	self.globalData.entity.manual_mode=true
	self.globalData.entity.manual_mode=previousMode
	for index,queueData in pairs(self.globalData.queue) do
		if queueData.isCurrent==false then
			self:addTrainStopToGui(index)
			return
		end
	end
end
