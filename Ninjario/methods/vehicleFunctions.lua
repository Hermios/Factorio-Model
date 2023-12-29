VehiclePrototype={}
ListInvisibleEntities={}
function VehiclePrototype:new(entity)
	if not entity or entity.valid==false or not listVehicles[entity.name] then
		return nil
	end
	local inventoryDefinitions
	if entity.type=="player" then 
		inventoryDefinitions={defines.inventory.player_quickbar,defines.inventory.player_main,defines.inventory.player_guns,defines.inventory.player_ammo,	defines.inventory.player_armor,	defines.inventory.player_tools,defines.inventory.player_trash}
	elseif entity.type=="locomotive" then
		inventoryDefinitions={defines.inventory.cargo_wagon}
	elseif entity.type=="car" then
		inventoryDefinitions={defines.inventory.car_trunk,defines.inventory.car_ammo}
	else
		return nil
	end
	local o = 
	{
		entity=entity,
		inventoryDefinitions=inventoryDefinitions
	}   
    return loadData(o,VehiclePrototype)
end

function VehiclePrototype:hasEquipment()
	--if self.entity.grid and self.entity.grid.get_contents()[invisibleEquipment] then
		return true
	--end
end

local function copyEntityToLocalData(entity,movingStateTable,saveTrainData,inventoryDefinitions)
	local result={}
	local trainOrEntityResult=result
	if entity.train then 
		result.train={} 
		trainOrEntityResult=result.train
	end
	result.position=entity.position
	result.orientation=entity.orientation
	result.direction=entity.direction
	result.force=entity.force
	result.health=entity.health
	--Save data of vehicles to replace
	if movingState then
		result[movingState["key"]]=movingState["value"]
	end
	if saveTrainData then
		trainOrEntityResult.speed=(entity.train or entity).speed
		trainOrEntityResult.schedule=(entity.train or {}).schedule
		trainOrEntityResult.manual_mode=(entity.train or {}).manual_mode
	end
	result.listContents={}
	for _,definition in pairs(inventoryDefinitions) do
		local inventory=entity.get_inventory(definition)
		if inventory then
			for item,count in pairs(inventory.get_contents()) do
				table.insert(result.listContents,{name=item,count=count})
			end
		end
	end
	
	local fuelContent=entity.get_fuel_inventory()
	--if entity.get_fuel_inventory then fuelContent=entity.get_fuel_inventory() end
	if fuelContent then
		for item,count in pairs(fuelContent.get_contents()) do
			table.insert(result.listContents,{name=item,count=count})
		end
	end	
	result.gridContent={}
	if entity.grid then
		for x=0,entity.grid.width do
			for y=0,entity.grid.width do
				local equipment=entity.grid.take{position={x,y}}
				if equipment then
					table.insert(result.gridContent,{position={x,y},name=equipment.name})
				end
			end
		end
	end
	return result
end

local function copylocalDataToEntity(entity,data)
	for key,value in pairs(data) do
		if key=="listContents" then
			for _,content in pairs(value) do
				entity.insert(content)
			end
		elseif key=="gridContent" then
			if entity.grid then 
				for _,data in pairs(value) do
					entity.grid.put(data)
				end
			end
		elseif type(value)=="table" then
			copylocalDataToEntity(entity[key],data[key])
		else
			entity[key]=value
		end
	end 
end

function VehiclePrototype:changeVisibility()
	if not self:hasEquipment() then
		return
	end
	local entityType=self.entity.type
	local movingState
	if entityType=="player" then 
		movingState={key="walking_state",value=self.entity.walking_state}
	else 
		movingState={key="riding_state",value=(self.entity.train or self.entity).riding_state}
	end
	local copiedData=copyEntityToLocalData(self.entity,movingState,true,self.inventoryDefinitions)
	local newName=listVehicles[self.entity.name]
	local isPlayerDriving=player.driving
	local entityId=self.entity.unit_number
	self.entity.destroy()
--Create the new items and put back items
	local newEntity
	if entityType=="player" then
		player.create_character(newName)
		newEntity=player.character
		newEntity.walking_state=movingState
	else
		newEntity=game.surfaces[1].create_entity{name=newName,position=copiedData.position}
	end
	self.entity=newEntity
	copylocalDataToEntity(newEntity,copiedData)
	player.driving=isPlayerDriving
	if not ListInvisibleEntities[entityId] then
		ListInvisibleEntities[newEntity.unit_number]=true
	else
		ListInvisibleEntities[entityId]=nil
	end
--create data for cargos
	if newEntity.train then
	local lastCarriage
		for index,carriage in ipairs(newEntity.train.carriages) do
			newName=listVehicles[carriage.name]
			if newName then
				copiedData=copyEntityToLocalData{entity=carriage,inventoryDefinitions=self.inventoryDefinitions}
				local newCarriage=game.surfaces[1].create_entity{name=newName}
				copylocalDataToEntity(newCarriage,copiedData)
				if index==#carriages then
					lastCarriage=newCarriage
				end
			end
		end
		if lastCarriage then
			lastCarriage.disconnect_rolling_stock(defines.rail_direction.back)
		end
	end
end