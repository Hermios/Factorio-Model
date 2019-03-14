ListPrototypesData={}
function initDataLibs(init)
	for _,content in pairs(ListPrototypesData) do
		content.prototype.__index=content.prototype
		if init then
			global[content.globalData]={}
		end		
		for index,data in pairs(global[content.globalData]) do
			content.localData[index]={}
			setmetatable(content.localData[index],content.prototype)
			content.localData[index].globalData=data
		end
	end
end

function getUnitId(entity)
	if not entity then
		return
	end
	if getmetatable(entity)==getmetatable(LuaTrain) then
		return entity.id
	elseif entity.train then
		return entity.train.id
	else
		return entity.unit_number
	end
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

local function recursiveCopyDataTable(oldTable,oldString,newString)
	local newTable={}
	for k,d in pairs(oldTable) do
		if not d then
			newTable[k]=nil
		elseif type(d)=="table" then
			newTable[k]=recursiveCopyDataTable(d,oldString,newString) 
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
	newEntity=recursiveCopyDataTable(newEntity,original,newName)
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

function clone(initTable)	
	if not initTable or type(initTable)~='table' then
		return initTable
	end
	local result={}
	for key,value in pairs(initTable) do
		if not string.starts(key,"_") then
			result[key]=clone(value)
		end
	end
	return result
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