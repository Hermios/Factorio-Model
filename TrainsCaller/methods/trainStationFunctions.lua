TrainStopPrototype={}

function TrainStopPrototype:new(entity)
    if entity.valid==false then
		return
	end
	--add receiver
	local receiverPosition=entity.position
	if entity.direction==0 then 
		receiverPosition.x=receiverPosition.x+0.5
		receiverPosition.y=receiverPosition.y+0.9
	elseif entity.direction==2 then 
		receiverPosition.x=receiverPosition.x+0.2
		receiverPosition.y=receiverPosition.y+0.6
	elseif entity.direction==4 then 
		receiverPosition.x=receiverPosition.x-0.5
		receiverPosition.y=receiverPosition.y+0.5
	elseif entity.direction==6 then 
		receiverPosition.x=receiverPosition.x-0.8
		receiverPosition.y=receiverPosition.y+0.5
	end
	local receiverDirection=entity.direction-2
	if receiverDirection==-2 then
		receiverDirection=6
	end
	local receiver=game.surfaces[1].create_entity{name=trainStopReceiver,position=receiverPosition,direction=receiverDirection,force=entity.force}
	receiver.destructible=false
	receiver.operable=false
	receiver.minable=false
	receiver.get_or_create_control_behavior().read_signal=false

	local o= 
	{
		globalData=
		{
			entity=entity,
			receiver=receiver,
			signalsPerTrain={},
			requestedSignals={}
		}
	}
	
    setmetatable(o, self)
	global.listTrainsStop[entity.unit_number]=o.globalData
	listTrainsStop[entity.unit_number]=o
	return o
end

function TrainStopPrototype:updateRequestedSignals()
	if self.globalData.entity.valid==false then
		return
	end
	--Check trains and signals
	for signalName,data in pairs(self.globalData.requestedSignals) do	
		--if train not valid, remove train
		if not listTrains[data.trainId] then
			self:removeTrain(data.trainId)
		--if train doesn't have signal, remove signal
		elseif listTrains[data.trainId]:hasSignal(data.signal)==false then
			self:removeSignal(signalName)
		end
	end
	
	--Add signals
	local listSignals=self.globalData.receiver.get_merged_signals() or {}
	local signalsDictionary={}
	for _,signalData in pairs(listSignals) do
		--Build dictionary
		signalsDictionary[signalData.signal.name]=signalData
		
		
		if not self.globalData.requestedSignals[signalData.signal.name] then
			local foundTrainId=self:findTrainForSignal(signalData.signal)
			if foundTrainId then
				self.globalData.requestedSignals[signalData.signal.name]={signal=signalData.signal,trainId=foundTrainId}
				self.globalData.signalsPerTrain[foundTrainId]=(self.globalData.signalsPerTrain[foundTrainId] or 0)+1
			end
		end
	end
	--Remove unused signals
	for signalName,_ in pairs(self.globalData.requestedSignals) do
		if not signalsDictionary[signalName] then
			self:removeSignal(signalName)
		end
	end 			
end

function TrainStopPrototype:findTrainForSignal(signalId)
	if self.globalData.entity.valid==false then
		return nil
	end
--search in trains already called
	for trainId,_ in pairs(self.globalData.signalsPerTrain) do
		if listTrains[trainId]:hasSignal(signalId) then
			return trainId
		end
	end
--search in trains not called by this trainStation yet
	local isTrainCallable=false
	local trainMaxCalls=#listTrainsStop
	local calledTrainId=nil
	for trainId,trainData in pairs(listTrains) do
		if trainData:hasSignal(signalId) then
			if  (isTrainCallable==false and (#trainData.globalData.queue<trainMaxCalls or trainData:isCallable()==true)) or 
				(isTrainCallable==true and #trainData.globalData.queue<trainMaxCalls and trainData:isCallable()==true) then
					isTrainCallable=trainData:isCallable()
					trainMaxCalls=#trainData.globalData.queue
					calledTrainId=trainId
			end
		end
	end
	if calledTrainId then
		listTrains[calledTrainId]:addTrainStop(self)
	end
	return calledTrainId
end

function TrainStopPrototype:removeSignal(signalName)
	if self.globalData.entity.valid==false then
		return
	end
	local trainId=self.globalData.requestedSignals[signalName].trainId
	--Decrease signals quantity for this train
	self.globalData.signalsPerTrain[trainId]=self.globalData.signalsPerTrain[trainId]-1
	--if no signals for this train, remove this train
	if self.globalData.signalsPerTrain[trainId]==0 then
		self:removeTrain(trainId)
		if listTrains[trainId] then
			listTrains[trainId]:removeTrainStop(self)
		end
	end
	self.globalData.requestedSignals[signalName]=nil
end

function TrainStopPrototype:removeTrain(trainId)
	if self.globalData.entity.valid==false then
		return
	end
	--remove signals for this train
	for signalName,data in pairs(self.globalData.requestedSignals) do 
		if data.trainId==trainId then
			self.globalData.requestedSignals[signalName]=nil
		end
	end
	
	--remove mapping train/trainStop
	self.globalData.signalsPerTrain[trainId]=nil
	if listTrains[trainId] then
		listTrains[trainId]:removeTrainStop(self)
	end
end

function TrainStopPrototype:removeFromTrainStopList()
	if self.globalData.entity.valid==false then
		return
	end
	if not listTrainsStop[self.globalData.entity.unit_number] then
		return
	end
	--cancel calls from trains
	for trainId,_ in pairs(self.globalData.signalsPerTrain) do
		listTrains[trainId]:removeTrainStop(self)
	end
	--destroy receiver
	self.globalData.receiver.destroy()
	--remove entry from the table "listTrainsStop"
	listTrainsStop[self.globalData.entity.unit_number]=nil
	global.listTrainsStop[self.globalData.entity.unit_number]=nil
end
