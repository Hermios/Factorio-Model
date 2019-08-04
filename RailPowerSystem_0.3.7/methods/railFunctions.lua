RailPrototype={}
railType={}
railType[electricStraightRail]="straight"
railType[electricCurvedRail]="curved"

function RailPrototype:new(entity)
	if entity.valid==false then
		return
	end
	
	local railNode=game.surfaces[1].create_entity{name=circuitNode,position=entity.position,force=entity.force}
	railNode.disconnect_neighbour()
	railNode.operable=false
	railNode.minable=false
	railNode.destructible=false
	railNode.disconnect_neighbour()
	local accu = game.surfaces[1].create_entity
		{
			name=railElectricAccu,
			position=railNode.position,
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
			railNode=railNode
		}
	}   
    setmetatable(o, self)
	listRails[entity.unit_number]=o
	global.listRails[entity.unit_number]=o.globalData
    return o
end

function RailPrototype:remove()
	self.globalData.accu.destroy()	
	self.globalData.railNode.destroy()
	listRails[self.globalData.entity.unit_number]=nil
	global.listRails[self.globalData.entity.unit_number]=nil
end

function RailPrototype:connectToOtherRails()
	local connectedRails={}
	for rail_direction=0,1 do
		for rail_connection_direction=0,2 do
			local connectedRail= self.globalData.entity.get_connected_rail{rail_direction=rail_direction,rail_connection_direction=rail_connection_direction}
			if connectedRail and listRails[connectedRail.unit_number] then
				connectAllWires(self.railNode,listRails[connectedRail.unit_number].globalData.railNode)
			end
		end
	end
end

function RailPoleConnectorPrototype:connectToRailPoleConnector()
	local x=self.globalData.entity.position.x
	local y=self.globalData.entity.position.y
	for _,railPole in pairs(game.surfaces[1].find_entities_filtered{area = {{x-1,y-1},{x+1,y+1}}, name=railPoleConnector}) do
		if listRailPoleConnectors[railPole.unit_number] then
			listRailPoleConnectors[railPole.unit_number]:connectToRail()
		end
	end
end