RoboportPrototype={}

function RoboportPrototype:new(entity)
	if entity.valid==false then
		return
	end
	local sender = entity.surface.create_entity({name="ghost-constant-combinator",position=entity.position,force=entity.force})
	sender.operable = false
	sender.minable = false
	sender.destructible = false
	entity.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
	entity.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
    local o = 
	{
		globalData=
		{
			entity=entity, 
			sender=sender
		}
	}   
    setmetatable(o, self)
	global.listRoboport[entity.unit_number]=o.globalData
	listRoboport[entity.unit_number]=o
	return o
end

function RoboportPrototype:setParameters(signals)
	self.globalData.sender.get_or_create_control_behavior().parameters={ parameters=signals or {} }
end

function RoboportPrototype:removeRoboport()
	listRoboport[self.globalData.entity.unit_number].globalData.sender.destroy()
	listRoboport[self.globalData.entity.unit_number]=nil
	global.listRoboport[self.globalData.entity.unit_number]=nil
end

function RoboportPrototype:setSignals()
	if not (self.globalData.guiData or {}).activate then
		return
	end	
	local signals={}
	local logisticCell=self.globalData.entity.logistic_cell
	local logistic_network=logisticCell.logistic_network
	if not logistic_network then
		return
	end
	local availableContents=logistic_network.get_contents()
	local area={{self.globalData.entity.position.x-logisticCell.construction_radius,self.globalData.entity.position.y-logisticCell.construction_radius},{self.globalData.entity.position.x+logisticCell.construction_radius,self.globalData.entity.position.y+logisticCell.construction_radius}}
	local ghostsRequired={}
	for _,ghostItem in pairs(game.surfaces[1].find_entities_filtered{area=area,name="entity-ghost"}) do
		local ghostItemName=ghostItem.ghost_prototype.items_to_place_this[1].name
		ghostsRequired[ghostItemName]=(ghostsRequired[ghostItemName] or 0)+1
	end
	for ghostProtoName,quantity in pairs(ghostsRequired) do
		local quantityToProvide=quantity-(availableContents[ghostProtoName] or 0)
		if quantityToProvide>0 then
			table.insert(signals,{count=quantityToProvide,signal={type="item",name=ghostProtoName},index=(#signals+1)})
		end
	end
	self:setParameters(signals)
end