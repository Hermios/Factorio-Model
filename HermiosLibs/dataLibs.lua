ListPrototypesData={}
changing_keys={"name","place_result","corpse","result","icon","filename","placed_as_equipment_result"}
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
local listKeysSetTo1={"x","y","height","width","frame_count","line_length","direction_count"}

local function recursiveSetEntityAsInvisible(entityTable)
	for key,value in pairs (entityTable) do
		if key=="connection_points" then
			entityTable[key] =
			{
				{
					shadow ={},
					wire =
					{
						copper = {0, 0},
						green = {0, 0},
						red = {0, 0}
					}
				},
			}
		elseif key=="red" or key=="green" or key=="copper" or (type(value)=="table" and string.find(key,"offset")) then
			entityTable[key]={0,0}
		elseif key=="shift" then
			entityTable[key]=nil
		elseif type(value)=="table" then
			entityTable[key]=recursiveSetEntityAsInvisible(value)
		elseif key=="icon" then
			entityTable[key] = "__HermiosLibs__/graphics/icons/empty.png"
		elseif key=="filename" and string.ends(value,"png") then
			entityTable[key]="__HermiosLibs__/graphics/entity/empty.png"
		elseif type(value)=="number" and has_value(listKeysSetTo1,key) then
			entityTable[key]=1
		end
	end
	return entityTable
end

function setEntityAsInvisible(entity)
	local variations=1
	recursiveSetEntityAsInvisible(entity)
	entity.drawing_box = nil
	entity.collision_box = nil
    entity.selection_box = nil
	entity.corpse=nil
	return entity
end

function getUnitId(entity)
	if not entity then
		return
	end	
	local result
	pcall(function () result=entity.id end)
	if not pcall(function() result=entity.train.id end) then
		pcall(function () result=entity.unit_number end)
	end
	return result
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
		elseif type(d)=="string" and has_value(changing_keys,k) then
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
    for _, value in ipairs (tab) do
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