RailPoleConnectorPrototype={}
local searchDirection = {{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1},{0,-1},{1,-1}}

function RailPoleConnectorPrototype:getConnectedRailId()
	local x=self.entity.position.x+searchDirection[self.entity.direction+1][1]
	local y=self.entity.position.y+searchDirection[self.entity.direction+1][2]
	return (game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, name= electricStraightRail}[1] or game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, name= electricCurvedRail}[1] or {}).unit_number
end

function RailPoleConnectorPrototype:new(entity,data)
	if entity.valid==false then
		return false
	end
	if entity.name==prototypeConnector then
		local position=entity.position
		local force=entity.force
		local direction=entity.direction
		entity.destroy()
		entity = game.surfaces[1].create_entity{name=railPoleConnector,position=position,force=force,direction=direction}
		entity.rotatable=false
		entity.disconnect_neighbour()
	end
	local groundNode=(data or {}).groundNode
	if not groundNode then
		groundNode = game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force}
		groundNode.disconnect_neighbour()
		connectAllWires(groundNode,entity)
	end
	local railNode=(data or {}).railNode
	if not railNode then
		local x=entity.position.x+searchDirection[entity.direction+1][1]
		local y=entity.position.y+searchDirection[entity.direction+1][2]
		railNode=game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force}
		railNode.disconnect_neighbour()
		connectAllWires(groundNode,railNode)
	end
	local o = data or
	{
		entity=entity,
		groundNode=groundNode,
		railNode=railNode
	}   
    setmetatable(o, self)
    self.__index = self
	return o
end

function RailPoleConnectorPrototype:remove()
	self.groundNode.destroy()
	self.railNode.destroy()
	listRails[self.entity.unit_number]=nil
end