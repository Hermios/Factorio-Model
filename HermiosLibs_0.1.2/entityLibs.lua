function addEquipmentCategory(entityType,categoryName)
	for _,prototype in pairs(data.raw[entityType]) do
		if not prototype.equipment_grid then
			return
		end
		local equipmentGrid=data.raw["equipment-grid"][prototype.equipment_grid]
		equipmentGrid.equipment_categories=equipmentGrid.equipment_categories or {}
		for _, category in pairs(equipmentGrid.equipment_categories) do
			if category == categoryName then
				found = true
				break
			end
		end
		if not found then
			table.insert(data.raw["equipment-grid"][prototype.equipment_grid].equipment_categories, categoryName)
		end
	end
end

function distance(entity1, entity2)
	local position1=entity1.position
	local position2=entity2.position
	return ((position1.x - position2.x)^2 + (position1.y - position2.y)^2)^0.5
end

function getEntityEvent(entity)
	if EventsControl[entity.name] then
		return EventsControl[entity.name]
	end
	if (EventsControl[entity.type] or {}).allowType then
		return EventsControl[entity.type]
	end
	return EventsControl["any"] or {}
end

function compareData(comparator,firstData,secondData)
	firstData=tonumber(firstData)
	secondData=tonumber(secondData)
	if not firstData or not secondData or not comparator then
		return false
	end
	if comparator==">" then
		return firstData>secondData
	elseif comparator=="=" then
		return firstData==secondData
	elseif comparator=="<" then
		return firstData<secondData
	end
end

function connectAllWires(ent1,ent2)	
	if ent1 and ent2 then
		ent1.connect_neighbour{wire=defines.wire_type.red,target_entity=ent2}
		ent1.connect_neighbour{wire=defines.wire_type.green,target_entity=ent2}
		ent1.connect_neighbour(ent2)
	end
end