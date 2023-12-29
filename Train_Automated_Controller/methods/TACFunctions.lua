TACEntity={}

function TACEntity:new(entity)
    if entity.valid==false then
		return
	end
	--set TAC
	local outputTac=game.surfaces[1].create_entity{name=OutputTAC,position=entity.position,direction=entity.direction,force=entity.force}		
	outputTac.rotatable=false
	outputTac.operable=false	
	outputTac.minable=false
	outputTac.destructible=false
	
	
	local inputTac=game.surfaces[1].create_entity{name=InputTAC,position=entity.position,direction=entity.direction,force=entity.force}
	outputTac.connect_neighbour{wire=defines.wire_type.red,target_entity=inputTac,target_circuit_id=2}
	outputTac.connect_neighbour{wire=defines.wire_type.green,target_entity=inputTac,target_circuit_id=2}
	--Get Train area
	local trainArea
	if entity.direction==0 then
		trainArea={{x=entity.position.x-2,y=entity.position.y-0.5},{x=entity.position.x-2,y=entity.position.y+0.5}}
	elseif entity.direction==2 then
		trainArea={{x=entity.position.x-0.5,y=entity.position.y-2},{x=entity.position.x+0.5,y=entity.position.y-2}}
	elseif entity.direction==4 then
		trainArea={{x=entity.position.x+2,y=entity.position.y-0.5},{x=entity.position.x+2,y=entity.position.y+0.5}}
	else
		trainArea={{x=entity.position.x-0.5,y=entity.position.y+2},{x=entity.position.x-0.5,y=entity.position.y+2}}
	end
	entity.active=false
	local o={
		globalData=
		{
			entity=inputTac,
			outputTac=outputTac,
			trainArea=trainArea,
			trainStopEntity=entity
		}
	}
	setmetatable(o, self)
	listTAC[inputTac.unit_number]=o
	global.listTAC[inputTac.unit_number]=o.globalData
	return o
end

function TACEntity:getTrain()
	for _,entity in pairs(game.surfaces[1].find_entities(self.globalData.trainArea)) do	
		if entity.train then
			return entity.train
		end
	end
end

function TACEntity:processRules()
	if not self.globalData.guiData then
		return
	end
	--init TAC
	self.globalData.outputTac.get_or_create_control_behavior().parameters=nil
	local train=self:getTrain()
	if not train then
		return
	end
	local i=1
	--process rules
	for _,rule in pairs(self.globalData.guiData.rules or {}) do
		local isruleApplied=(rule.conditions~=nil)
		for _,condition in pairs(rule.conditions or {}) do
			if condition.areAllParametersFilled and listPrototypesConditions[condition.method or ""] then
				if not listPrototypesConditions[condition.method].method(train,self.globalData.entity.get_merged_signals(defines.circuit_connector_id.combinator_input) or {},condition.parameters) then									
					isruleApplied=false
					break
				end
			end
		end
		if isruleApplied then			
			for _,action in pairs(rule.actions or {}) do
				if action.method and listPrototypesActions[action.method] then
					local signalData=listPrototypesActions[action.method].method(train,action.parameters)
					if (signalData or {}).signal and (signalData or {}).count then
						self.globalData.outputTac.get_or_create_control_behavior().set_signal(i,signalData)
						i=i+1
					end
				end
			end
		end
	end
end

function TACEntity:remove()
	self.globalData.outputTac.destroy()
	self.globalData.trainStopEntity.destroy()
	global.listTAC[self.globalData.entity.unit_number]=nil
	listTAC[self.globalData.entity.unit_number]=nil
end