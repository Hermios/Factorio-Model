function onGlobalBuilt(entity)
	if entity.type=="electric-pole" then	
		for _,neighbour in pairs(entity.neighbours.copper) do
			if neighbour.name == ghostElectricPoleNotSelectable or entity.name==ghostElectricPoleNotSelectable then
				entity.disconnect_neighbour(neighbour)
			end
		end
	end
end

function OnBuildEntity(entity)
	-- remove automatic connected cables
	if entities[entity.name] and entities[entity.name].onBuilt then
		entities[entity.name].onBuilt(entity)
	end	
end

function OnPreRemoveEntity(entity)
	if entities[entity.name] and entities[entity.name].onRemove then
		entities[entity.name].onRemove(entity)
	end	
end

function OnTick()
	for _,eTrain in pairs(global.electricTrains) do
		if eTrain and eTrain.valid and entities[eTrain.name] and entities[eTrain.name].onTick then
			entities[eTrain.name].onTick(eTrain)
		end
	end
end

entityghosts.onBuilt=function(entity)
	local ghost_name= entity.ghost_prototype.name

	if ghost_name==ghostElectricPole then
		game.surfaces[entity.surface.name].create_entity{
			name="entity-ghost",
			position=entity.position,
			force=entity.force,
			inner_name=railPole,
		}
		entity.destroy()
	end
end

electricPole.onBuilt=function(entity)
	local newEntity=addGhostEntity(entity,{entity.position.x,entity.position.y},ghostElectricPole,true)	
	local floorEntity=addGhostEntity(entity,{entity.position.x,entity.position.y},ghostElectricPoleNotSelectable,false)	
	connectWires(floorEntity,newEntity)
	local railToConnect=railFromPole(entity,straightRailPower) or railFromPole(entity,curvedRailPower)
	connectWires(floorEntity,closestRailGhostEntity(floorEntity,railToConnect))	
	entity.destroy()
end

railPower.onBuilt=function(entity)
	local ghostEntities={}
	for i,node in pairs(nodesPositions(entity)) do
		ghostEntities[i]=addGhostEntity(entity,node,ghostElectricPoleNotSelectable,false)		
	end	
	
	local ghostAccu=addGhostEntity(entity,entity.position,railAccu,false)
	
	connectGhostsInsideRail(entity)
	
	--connect to all possible rails
	for _,railDir in pairs(defines.rail_direction) do
		for _,railConnDir in pairs(defines.rail_connection_direction) do
			if railConnDir~=defines.rail_connection_direction.none then			
				local connectedRail=entity.get_connected_rail{rail_direction=railDir,rail_connection_direction=railConnDir}
				if connectedRail and (connectedRail.name==straightRailPower or connectedRail.name==curvedRailPower) then
					local firstGhostEntity=nil
					local secondGhostEntity=nil
					local localDistance=99999999
					for _,ghostEntity in pairs(ghostEntities) do
						local closestGhost=closestRailGhostEntity(ghostEntity,connectedRail)		
						if closestGhost and distance(ghostEntity,closestGhost)<localDistance then														
							localDistance=distance(ghostEntity,closestGhost)
							firstGhostEntity=ghostEntity
							secondGhostEntity=closestGhost
						end
					end
					connectWires(firstGhostEntity,secondGhostEntity)				
				end
			end
		end
	end
end

ghostElectricPoles.onRemove=function(entity)
	for _,ghostEntity in pairs(poleGhostEntities(entity)) do
		if ghostEntity and ghostEntity.valid then
			ghostEntity.destroy()
		end
	end
end

electricPole.onRemove=function(entity)
end

railPower.onRemove=function(entity)
	for _,ghostEntity in pairs(railGhostEntities(entity)) do
		if ghostEntity and ghostEntity.valid then
			ghostEntity.destroy()
		end
	end
	local ghostRailAccuEntity=ghostRailAccu(entity)
	if ghostRailAccuEntity and ghostRailAccuEntity.valid then
		ghostRailAccuEntity.destroy()
	end
end