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
	
	local o =
	{
		globalData=
		{
			direction=entity.direction,
			entity=poleEntity			
		}
	}   	
	entity.destroy()
	setmetatable(o, self)	
	global.listRailPoleConnectors[poleEntity.unit_number]=o.globalData
	listRailPoleConnectors[poleEntity.unit_number]=o
	return o
end

function RailPoleConnectorPrototype:connectToRail()
	local x=self.globalData.entity.position.x+searchDirection[self.globalData.direction+1][1]
	local y=self.globalData.entity.position.y+searchDirection[self.globalData.direction+1][2]
	local railEntity= listRails[
		(game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, type= electricStraightRail}[1]
		or game.surfaces[1].find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, type= electricCurvedRail}[1]
		or {})
			.unit_number 
			or ""]	
	if railEntity then 
		connectAllWires(self.globalData.entity,railEntity.railNode)
	end
end

function RailPoleConnectorPrototype:remove()
	listRailPoleConnectors[self.globalData.entity.unit_number]=nil
end