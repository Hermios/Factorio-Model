listPrototypesActions={}
function addToActions(content)
	for _,parameter in pairs(content.parameters) do
		parameter.onAction=OnParameterAction
	end
	listPrototypesActions[content.text[1]]=content
end

function getLocalActionsList()
	local result={}
	table.insert(result,	{	
											method=SetSignal,
												parameters= {
																{type="choose-elem-button",elem_type="signal",name="signal"},
																{type="textfield",name="quantity",regexp="%d+"}
															},
												text={"returning-signal"}
											})
	table.insert(result,	{	
											method=SetManualMode,
												parameters= {
																{type="checkbox",state=false,name="isManual"},
															},
												text={"set-manual-mode"}
											})
	table.insert(result,	{	
											method=AddStation,
												parameters=	{
													{type="drop-down",name="station",onInit=setListTrainsStops}
														},
												text={"add-station"}
											})
	table.insert(result,	{	
											method=RemoveStation,
												parameters=	{
												{type="drop-down",name="station",onInit=setListTrainsStops}
														},
												text={"remove-station"}
											})
	table.insert(result,	{	
											method=ClearSchedule,
												parameters=	{
														},
												text={"clear-schedule"}
											})
	table.insert(result,	{	
											method=ConnectTrain,
												parameters=	{
													{type="checkbox",state=false,name="toConnect"},
														},
												text={"connect-train"}
											})	
	table.insert(result,	{	
											method=GoToStation,
												parameters=	{
												{type="drop-down",name="station",onInit=setListTrainsStops},
												{type="checkbox",state=false,name="addIfNonExistent",caption={"addStationIfNonExistent"}},
														},
												text={"go-to-station"}
											})
												
		return result
end

function SetSignal(train,params)
	return {signal=params.signal,count=params.quantity}
end

function SetManualMode(train,params)
	train.manual_mode=params.isManual
end

function AddStation(train,params)
	if not params.station then
		return
	end
	local schedule=clone(train.schedule) 
	schedule=schedule or {records={},current=1}
	table.insert(schedule.records,{station=params.station})
	train.schedule=schedule
end

function RemoveStation(train,params)
	if not train.schedule then
		return
	end
	local schedule=clone(train.schedule)
	for index,stationData in ipairs(schedule.records) do
		if stationData.station==params.station then
			if schedule.current==index and current==#schedule.records then
				current=1
			end
			table.remove(schedule.records,index)
			train.schedule=schedule
			return
		end
	end
end

function ClearSchedule (train, params)
	train.schedule=nil
end

function ConnectTrain(train,params)
	local carriage=train.carriages[1]
	if params.toConnect then
		carriage.connect_rolling_stock(defines.rail_direction.front)
		carriage.connect_rolling_stock(defines.rail_direction.back)
	else
		carriage.disconnect_rolling_stock(defines.rail_direction.front)
		carriage.disconnect_rolling_stock(defines.rail_direction.back)
	end
end

function GoToStation(train,params)
	local schedule=clone(train.schedule)
	schedule=schedule or {records={}}
	for index,stationData in ipairs(schedule.records) do
		if stationData.station==params.station then
			train.go_to_station(index)
			return
		end
	end
	if params.addIfNonExistent then
		AddStation(train,params)
		train.go_to_station(#train.schedule.records)
	end
end