function InitDataLibs()
	player=game.players[1]
end

function getFirstKey(dictionary)
if not dictionary then
	return nil
end
for key,_ in pairs(dictionary) do
	return key
end
return nil
end

local function recursiveCopyTable(oldTable,oldString,newString)
	local newTable={}
	for k,d in pairs(oldTable) do
		if not d then
			newTable[k]=nil
		elseif type(d)=="table" then
			newTable[k]=recursiveCopyTable(d,oldString,newString) 
		elseif type(d)=="string" and k~="type" then
			newTable[k]=d
			if string.ends(newTable[k],"/"..oldString..".png") then
				newTable[k]=string.gsub(newTable[k],"__%a-__/(.+)","__"..ModName.."__/%1")
			end
			if string.find(newTable[k],"__"..ModName.."__") or not string.find(newTable[k],"__%a-__") then
				newTable[k]=newTable[k]:gsub(oldString:gsub("%-","%%-"),newString)		
			end
		else
			newTable[k]=d
		end
	end
	return newTable
end

createData=function(objectType,original,newName,newData)
	local newEntity=table.deepcopy(data.raw[objectType][original])
	if newEntity == nil then
		err("could not overwrite content of "..original.." with new content: "..serpent.block(newContent))
		return nil
	end
	newEntity=recursiveCopyTable(newEntity,original,newName)
	if newData then
		for k,d in pairs(newData) do
				newEntity[k]=d
		end
	end
	data:extend({newEntity})	
	return newEntity
end


has_value =function(tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end
    return false
end

get_index=function(tab,val)
	while tab[i]~=nil and tab[i]~=val do
		i=i+1
	end
	if tab[i]==nil then
		return nil
	else
		return i
	end
end

function removeVal(tab,val)
	table.remove(tab,get_index(tab,val))
end

function distance(entity1, entity2)
	local position1=entity1.position
	local position2=entity2.position
	return ((position1.x - position2.x)^2 + (position1.y - position2.y)^2)^0.5
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
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