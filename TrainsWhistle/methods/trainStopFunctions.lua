TrainStopPrototype={}

function TrainStopPrototype:new(entity)
	if entity.valid==false then
		return
	end
	local pos1=entity.position
	local pos2=entity.position
	if entity.direction==0 then
		pos1.x=pos1.x+2
		pos2.x=pos1.x-5
	elseif entity.direction==2 then
		pos1.y=pos1.y+2
		pos2.y=pos1.y-5
	end
	local o = 
	{
		globalData={
			entity=entity,
			positions={pos1,pos2}
		}
	} 
    setmetatable(o, self)
	global.listTrainStops[entity.unit_number]=o.globalData
	listTrainStops[entity.unit_number]=o
	return o
end

function TrainStopPrototype:findTrain(attemptId)
	local direction=self.globalData.entity.direction-(4*(attemptId-1))
	if direction<0 then
		direction=self.globalData.entity.direction+(4*(attemptId-1))
	end
	local trainStation=game.surfaces[1].create_entity
	{
		name=trainStopGhost,
		force=game.players[1].force,
		position=self.globalData.positions[attemptId],
		direction=direction
	}
	if not trainStation then return false end
	for _,trainData in pairs(listTrains) do
		if trainData:isFree()==true and trainData:addStation(trainStation,self.globalData.entity.unit_number) then
			self.globalData.station=trainStation
			game.players[1].print({"train_ok",math.floor(distance(trainData.globalData.entity.locomotives.front_movers[1],trainStation))})
			return true
		end
	end
	trainStation.destroy()
	return false
end

function TrainStopPrototype:remove()
	global.listTrainStops[self.globalData.entity.unit_number]=nil
	listTrainStops[self.globalData.entity.unit_number]=nil
end