RoboportPrototype={}

function RoboportPrototype:new(entity,data)
	if entity.valid==false then
		return false
	end
	local sender=(data or {}).sender
	if not sender then
		sender = entity.surface.create_entity({name="ghost-constant-combinator",position=entity.position,force=entity.force})
		sender.operable = false
		sender.minable = false
		sender.destructible = false
		entity.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
		entity.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
	end
    local o = data or
	{
		entity=entity, 
		sender=sender
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function RoboportPrototype:setParameters(signals)
	self.sender.get_or_create_control_behavior().parameters={ parameters=signals or {} }
end

function RoboportPrototype:removeRoboport()
	listRoboport[self.entity.unit_number].sender.destroy()
	listRoboport[self.entity.unit_number]=nil
end

function RoboportPrototype:setSignals()
	local signals={}
	local logisticCell=self.entity.logistic_cell
	local availableContents=logisticCell.logistic_network.get_contents()
	local area={{self.entity.position.x-logisticCell.construction_radius,self.entity.position.y-logisticCell.construction_radius},{self.entity.position.x+logisticCell.construction_radius,self.entity.position.y+logisticCell.construction_radius}}
	local ghostsRequired={}
	for _,ghostItem in pairs(game.surfaces[1].find_entities_filtered{area=area,name="entity-ghost"}) do
		ghostsRequired[ghostItem.ghost_prototype.name]=(ghostsRequired[ghostItem.ghost_prototype.name] or 0)+1
	end
	for ghostProtoName,quantity in pairs(ghostsRequired) do
		local quantityToProvide=quantity-(availableContents[ghostProtoName] or 0)
		if quantityToProvide>0 then
			table.insert(signals,{count=quantityToProvide,signal={type="item",name=ghostProtoName},index=(#signals+1)})
		end
	end
	self:setParameters(signals)
end