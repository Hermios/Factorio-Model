function distance(entity1, entity2)
	local position1=entity1.position
	local position2=entity2.position
	return ((position1.x - position2.x)^2 + (position1.y - position2.y)^2)^0.5
end

function compareData(comparator,firstData,secondData)
	if not firstData or not secondData or not comparator then
		return false
	end
	firstData=tonumber(firstData)
	secondData=tonumber(secondData)
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