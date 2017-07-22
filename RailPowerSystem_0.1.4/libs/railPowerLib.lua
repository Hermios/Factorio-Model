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
	if not rail then
		return result
	end
	if string.starts(rail.name,"curved") then
		result[1]={rail.position.x+curvedRailpointsPositions[rail.direction+1][1][1],rail.position.y+curvedRailpointsPositions[rail.direction+1][1][2]}
		result[2]={rail.position.x,rail.position.y}
		result[3]={rail.position.x+curvedRailpointsPositions[rail.direction+1][2][1],rail.position.y+curvedRailpointsPositions[rail.direction+1][2][2]}
	elseif string.starts(rail.name,"straight") then
		result[1]={rail.position.x,rail.position.y}
	end	
	return result
end