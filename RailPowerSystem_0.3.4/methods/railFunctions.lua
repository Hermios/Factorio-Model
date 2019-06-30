local curvedRailpointsPositions={
{{x=-1.2,y=-2.2},{x=0,y=0},{x=1.2,y=2.2}},
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
railType[electricStraightRail]="straight"
railType[electricCurvedRail]="curved"

local createNodes=function(entity)
	local result={}
	if not entity or not entity.valid then
		return result
	end	
	if entity.type=="curved-rail" then
		for index,position in ipairs(curvedRailpointsPositions[entity.direction+1]) do
			table.insert(result,game.surfaces[1].create_entity{
				name=circuitNode,
				position={
					entity.position.x+position.x,
					entity.position.y+position.y
				},
				force=entity.force
			})
		end
	else
		table.insert(result,game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force})
	end	
	for index,node in ipairs(result) do 
		node.disconnect_neighbour()
		if index>1 then
			connectAllWires(result[index-1],node)
		end
	end
	return result
end

function RailPrototype:new(entity)
	if entity.valid==false then
		return
	end
	
	local circuitNodes=createNodes(entity) 
	local accu = game.surfaces[1].create_entity
		{
			name=railElectricAccu,
			position=(circuitNodes[2] or circuitNodes[1]).position,
			force=entity.force
		}
	accu.operable = false
	accu.minable = false
	accu.destructible = false
	local o=
	{
		globalData=
		{
			entity=entity, 
			accu=accu,
			circuitNodes=circuitNodes
		}
	}   
    setmetatable(o, self)
	listRails[entity.unit_number]=o
	global.listRails[entity.unit_number]=o.globalData
    return o
end

function RailPrototype:connectCloserNodes(entity2)
	local minDistance
	local resultNode1
	local resultNode2
	local listNodes2=entity2.circuitNodes or {entity2.railNode}
	for _,node1 in pairs(self.globalData.circuitNodes) do
		if node1.valid then
			for _,node2 in pairs(listNodes2) do
				if node2.valid then		
					local currentDistance=distance(node1,node2)
					if not minDistance or currentDistance<minDistance then
						minDistance=currentDistance
						resultNode1=node1
						resultNode2=node2
					end
				end
			end	
		end
	end
	if resultNode1 and resultNode2 then
		connectAllWires(resultNode1,resultNode2)
	end
end
	
function RailPrototype:remove()
	self.globalData.accu.destroy()
	for _,circuitNode in pairs(self.globalData.circuitNodes) do
		circuitNode.destroy()
	end
	listRails[self.globalData.entity.unit_number]=nil
	global.listRails[self.globalData.entity.unit_number]=nil
end

function RailPrototype:getConnectableRailPoleConnectors()
	local searchArea={{self.globalData.entity.boundingBox.left_top.x-0.5,self.globalData.entity.boundingBox.left_top.y-0.5},{self.globalData.entity.boundingBox.right_bottom.x+0.5,self.globalData.entity.boundingBox.right_bottom.y+0.5}}
	local connectedConnectors={}
	for _,railPoleConnector in pairs(game.surface[1].find_entities_filtered{area=searchArea,name=prototypeConnector}) do
		if listRailPoleConnectors[railPoleConnector.unit_number].getConnectedRailId()==self.globalData.entity.id then
			table.insert(connectedConnectors,railPoleConnector)
		end
	end
	return connectedConnectors
end

function RailPrototype:connectToOtherRails()
	local connectedRails={}
	for rail_direction=0,1 do
		for rail_connection_direction=0,2 do
			local connectedRail= self.globalData.entity.get_connected_rail{rail_direction=rail_direction,rail_connection_direction=rail_connection_direction}
			if connectedRail and listRails[connectedRail.unit_number] then
				self:connectCloserNodes(listRails[connectedRail.unit_number].globalData)
			end
		end
	end
end