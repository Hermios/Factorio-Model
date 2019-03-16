listPrototypesConditions={}

function addToConditions(content)
	for _,parameter in pairs(content.parameters) do
		parameter.onAction=OnParameterAction
	end
	listPrototypesConditions[content.text[1]]=content
end

function getLocalConditionsList()
	local result={}
	table.insert(result,	{	method=ConditionSignals,
												parameters= {
													{type="label",caption={"train"},name="source1"},
													{type="choose-elem-button",elem_type="signal",name="signal1"},
													{type="drop-down",items={"<","=",">"},name="comparator"},
													{type="label",caption={"network"},name="source2"},
													{type="choose-elem-button",elem_type="signal",name="signal2"}
														},
												text={"condition-signals"}
											})
	table.insert(result,	{	method=ConditionSignalQuantity,
												parameters=	{
													{type="drop-down",items={{"train"},{"network"}},name="source"},
													{type="choose-elem-button",elem_type="signal",name="signal"},
													{type="drop-down",items={"<","=",">"},name="comparator"},
													{type="textfield",name="quantity",regexp="%d+"}
														},
												text={"condition-signal-quantity"}
											})
	table.insert(result,	{	method=ConditionStationName,
												parameters=	{
													{type="drop-down",name="station",onInit=setListTrainsStops}
														},
												text={"condition-station-name"}
											})
	table.insert(result,	{	method=ConditionStationsQuantity,
												parameters={
													{type="drop-down",items={"<","=",">"},name="comparator"},
													{type="textfield",name="quantity",regexp="%d+"}
													},
												text={"condition-stations-quantity"}
											})
	table.insert(result,	{	method=ConditionTrainState,
												parameters=	{
													{type="drop-down",items={{"on the path"},{"path lost"},{"no schedule"},{"no path"},{"arrive signal"},{"wait signal"},{"arrive station"},{"wait station"},{"manual control stop"},{"manual control"}},name="trainState"}
														},
												text={"condition-train-state"}
											})
	table.insert(result,	{	method=ConditionTrainComposition,
												parameters=	{
													{type="drop-down",items={{"cargo_wagon"},{"fluid_wagon"},{"artillery_wagon"}},name="carriageType"},
													{type="drop-down",items={"<","=",">"},name="comparator"},
													{type="textfield",name="quantity",regexp="%d+"}
													},
												text={"condition-composition-wagon"}
											})
	return result
end

local function getSignalQty(source,signalID,train,signals)
	local result
	if source=="train" then
		if signalID.type=="item" then
			result=train.get_item_count(signalID.name)
		elseif signalID.type=="fluid" then
			result=train.get_fluid_count(signalID.name)		
		end
		return result
	else
		for _,signal in pairs(signals) do
			if signal.signal.name==signalID.name then
				return signal.count
			end
		end
	end
end

function ConditionSignals(train,signals,params)
	local signal1Qty=getSignalQty("train",params.signal1,train,signals)
	local signal2Qty=getSignalQty("network",params.signal2,train,signals)
	return compareData(params.comparator,signal1Qty,signal2Qty)
end

function ConditionSignalQuantity(train,signals,params)
	local signal1Qty=getSignalQty(params.source,params.signal,train,signals)	
	return compareData(params.comparator,signal1Qty,params.quantity)
end

function ConditionStationName(train,signals,params)
	for _,record in pairs(train.schedule.records) do
		if record.station==params.station then
			return true
		end
	end
	return false
end

function ConditionStationsQuantity(train,tac,params)
	return compareData(params.comparator,#train.schedule.records,params.stationsQuantity)
end

function ConditionTrainState(train,tac,params)
	return defines.train_state[string.gsub(params.trainState," ","_")]==train.state
end

function ConditionTrainComposition(train,tac,params)
	local quantity=0
	for _,carriage in pairs(train.carriages) do
		if carriage.type==params.carriageType then
			quantity=quantity+1
		end
	end
	return compareData(params.comparator,quantity,params.quantity)
end

