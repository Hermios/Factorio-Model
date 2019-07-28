RailPoleConnectorPrototype={}
local searchDirection = {{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1},{0,-1},{1,-1}}

function RailPoleConnectorPrototype:new(entity,data)
	if entity.valid==false then
		return
	end
	local poleEntity = game.surfaces[1].create_entity{name=railPoleConnector,position=entity.position,force=entity.force}
		for _,neighbourTable in pairs(poleEntity.neighbours) do
			for _,neighbour in pairs(neighbourTable)do		
				if neighbour.name==circuitNode then
					poleEntity.disconnect_neighbour(neighbour)
				end
			end
		end
		poleEntity.minable=false
		poleEntity.destructible=false
		poleEntity.operable=false
	local groundNode = game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force}
	groundNode.minable=false
	groundNode.destructible=false
	groundNode.operable=false
	groundNode.disconnect_neighbour()
	connectAllWires(groundNode,poleEntity)

	local x=entity.position.x+searchDirection[entity.direction+1][1]
	local y=entity.position.y+searchDirection[entity.direction+1][2]
	local railNode=game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force}
	railNode.minable=false
	railNode.destructible=false
	railNode.operable=false
	railNode.disconnect_neighbour()
	connectAllWires(groundNode,railNode)
	
	local o =
	{
		globalData=
		{
			direction=entity.direction,
			entity=poleEntity,
			groundNode=groundNode,
			railNode=railNode,
			prototypeEntity=entity
		}
	}   
	for _,rail in pairs(entity.get_connected_rails()) do
		if listRails[rail.unit_number] then
			listRails[rail.unit_number]:connectCloserNodes(o.globalData)
		end
	end
	entity.active=false
	setmetatable(o, self)
	global.listRailPoleConnectors[poleEntity.unit_number]=o.globalData
	listRailPoleConnectors[poleEntity.unit_number]=o
	return o
end

function RailPoleConnectorPrototype:getConnectedRailId()
	local x=self.globalData.entity.position.x+searchDirection[self.globalData.direction+1][1]
	local y=self.globalData.entity.position.y+searchDirection[self.globalData.direction+1][2]
	return (game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, name= electricStraightRail}[1] or game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, name= electricCurvedRail}[1] or {}).unit_number
end

function RailPoleConnectorPrototype:remove()
	self.globalData.groundNode.destroy()
	self.globalData.railNode.destroy()
	self.globalData.prototypeEntity.destroy()
	listRailPoleConnectors[self.globalData.entity.unit_number]=nil
end