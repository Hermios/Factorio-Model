local curvedRailpointsPositions={
{{-1.2,-2.2},{1.2,2.2}},
{{-1.2,2.2},{1.2,-2.2}},
{{-2.2,1.2},{2.2,-1.2}},
{{-2.2,-1.2},{2.2,1.2}},
{{-1.2,-2.2},{1.2,2.2}},
{{-1.2,2.2},{1.2,-2.2}},
{{-2.2,1.2},{2.2,-1.2}},
{{-2.2,-1.2},{2.2,1.2}},
}

local straightRailPointsPositions={
{0,0},
{},
{},
{},
{},
{},
{},
{},
}

local searchDirection = {{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1},{0,-1},{1,-1}}

railFromPole=function(entity,expectedItemType)
	local x=entity.position.x+searchDirection[entity.direction+1][1]
	local y=entity.position.y+searchDirection[entity.direction+1][2]
	return entity.surface.find_entities_filtered{area = {{x-0.5,y-0.5},{x+0.5,y+0.5}}, name= expectedItemType}[1]
end

poleGhostEntities=function(entity)
	local x=entity.position.x
	local y=entity.position.y
	return entity.surface.find_entities_filtered{area={{x-0.5,y-0.5},{x+0.5,y+0.5}},name=ghostElectricPoleNotSelectable}
end

function connectWires(firstGhost,secondGhost)	
	if firstGhost and secondGhost then
		firstGhost.connect_neighbour{wire=defines.wire_type.red,target_entity=secondGhost}
		firstGhost.connect_neighbour{wire=defines.wire_type.green,target_entity=secondGhost}
		firstGhost.connect_neighbour(secondGhost)
	end
end

function connectGhostsInsideRail(rail)
	local ghostRailsEntities=railGhostEntities(rail)
	if #ghostRailsEntities<2 then
		return
	end
	for i=1,#ghostRailsEntities-1,1 do
		connectWires(ghostRailsEntities[i],ghostRailsEntities[i+1])		
	end
end

function addGhostEntity(entity,position,ghostEntityName,setConfig)
	local ghostCreated= entity.surface.create_entity{name=ghostEntityName, position=position,force=entity.force}	
	ghostCreated.operable=setConfig
	ghostCreated.destructible=setConfig
	ghostCreated.minable=setConfig	
	onGlobalBuilt(ghostCreated)
	return ghostCreated
end

ghostRailAccu=function(entity)
	return entity.surface.find_entities_filtered{area={{entity.position.x-0.5,entity.position.y-0.5},{entity.position.x+0.5,entity.position.y+0.5}},name=railAccu}[1]
end

closestRailGhostEntity=function (entity,rail)
	local localDistance=999999
	local result=nil	
	for _,railGhost in pairs(railGhostEntities(rail)) do	
		if distance(entity,railGhost)<localDistance then
			localDistance=distance(entity,railGhost)
			result=railGhost
		end
	end
	return result
end

railGhostEntities=function(entity)
	ghostEntities={}
	for i,node in pairs(nodesPositions(entity)) do	
		ghostEntities[i]= entity.surface.find_entities_filtered{area={{node[1]-0.5,node[2]-0.5},{node[1]+0.5,node[2]+0.5}},name=ghostElectricPoleNotSelectable}[1]
	end
	return ghostEntities
end

function nodesPositions(rail)
	result={}
	if not rail or not rail.valid or not railType[rail.name] then
		return result
	end
	if railType[rail.name]=="curved" then
		result[1]={rail.position.x+curvedRailpointsPositions[rail.direction+1][1][1],rail.position.y+curvedRailpointsPositions[rail.direction+1][1][2]}
		result[2]={rail.position.x,rail.position.y}
		result[3]={rail.position.x+curvedRailpointsPositions[rail.direction+1][2][1],rail.position.y+curvedRailpointsPositions[rail.direction+1][2][2]}
	elseif railType[rail.name]=="straight" then
		result[1]={rail.position.x,rail.position.y}
	end	
	return result
end