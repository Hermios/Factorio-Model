local curvedRailpointsPositions={
{{x=-1.2,y=-2.2},{x=0,y=0},{x=1.2,2.2}},
{{x=-1.2,y=2.2},{x=0,y=0},{x=1.2,y=-2.2}},
{{x=-2.2,y=1.2},{x=0,y=0},{x=2.2,y=-1.2}},
{{x=-2.2,y=-1.2},{x=0,y=0},{x=2.2,y=1.2}},
{{x=-1.2,y=-2.2},{x=0,y=0},{x=1.2,y=2.2}},
{{x=-1.2,y=2.2},{x=0,y=0},{x=1.2,y=-2.2}},
{{x=-2.2,y=1.2},{x=0,y=0},{x=2.2,y=-1.2}},
{{x=-2.2,y=-1.2},{x=0,y=0},{x=2.2,y=1.2}},
}

RailPrototype={}
railType={}

function RailPrototype:connectCloserNodes(entity2)
	local minDistance
	local resultNode1
	local resultNode2
	local listNodes2=entity2.circuitNodes or {entity2.railNode}
	for _,node1 in pairs(self.circuitNodes) do
		for _,node2 in pairs(listNodes2) do
			local currentDistance=distance(node1,node2)
			if not minDistance or currentDistance<minDistance then
				minDistance=currentDistance
				resultNode1=node1
				resultNode2=node2
			end
		end	
	end
	if resultNode1 and resultNode2 then
		connectAllWires(resultNode1,resultNode2)
	end
end

local createNodes=function(entity)
	local result={}
	if not entity or not entity.valid then
		return result
	end	
	if entity.type=="curved-rail" then
		for index,position in ipairs(curvedRailpointsPositions[entity.direction]) do
			table.insert(result,game.surfaces[1].create_entity{name=circuitNode,position=position,force=entity.force})
			result[index].disconnect_neighbour()
			if index>1 then
				connectAllWires(result[index-1],result[index])
			end
		end
	else
		table.insert(result,game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force})
	end	
	return result
end

function RailPrototype:new(entity,data)
	if entity.valid==false then
		return false
	end
	local accu=(data or {}).accu
	if not accu then
		accu = game.surfaces[1].create_entity{name=railElectricAccu,position=entity.position,force=entity.force}
		accu.operable = false
		accu.minable = false
		accu.destructible = false
	end
	local circuitNodes=(data or {}).circuitNodes or createNodes(entity) 
	local o = data or
	{
		entity=entity, 
		accu=accu,
		circuitNodes=circuitNodes
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function RailPrototype:remove()
	self.accu.destroy()
	for _,circuitNode in pairs(self.circuitNodes) do
		circuitNode.destroy()
	end
	listRails[self.entity.unit_number]=nil
end

function RailPrototype:getConnectableRailPoleConnectors()
	local searchArea={{self.entity.boundingBox.left_top.x-0.5,self.entity.boundingBox.left_top.y-0.5},{self.entity.boundingBox.right_bottom.x+0.5,self.entity.boundingBox.right_bottom.y+0.5}}
	local connectedConnectors={}
	for _,railPoleConnector in pairs(game.surface[1].find_entities_filtered{area=searchArea,name=prototypeConnector}) do
		if listRailPoleConnectors[railPoleConnector.unit_number].getConnectedRailId()==self.entity.id then
			table.insert(connectedConnectors,railPoleConnector)
		end
	end
	return connectedConnectors
end

function RailPrototype:connectToOtherRails()
	local connectedRails={}
	for rail_direction=1,2 do
		for rail_connection_direction=1,3 do
			for _,rail in pairs(self.entity.get_connected_rail{rail_direction=rail_direction,rail_connection_direction=rail_connection_direction}) do
				if rail and listRails[rail.unit_number] then
					self:connectCloserNodes(listRails[rail.unit_number])
				end
			end
		end
	end
end