--equipment categories
data:extend
  {
    {
      type = "equipment-category",
      name = trainWhistleEquipment
    },
	{
      type = "equipment-grid",
      name = trainWhistleEquipmentGrid,
      width = 2,
      height = 2,
      equipment_categories = {trainWhistleEquipment},
    },
}

-- Equipment
local createdEquipment=createData("movement-bonus-equipment","exoskeleton-equipment",trainWhistleEquipment,
{
	energy_consumption = "20W",
	movement_bonus = 0,
	shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
	sprite =
    {
      filename = "__"..ModName.."__/graphics/equipment/"..trainWhistleEquipment..".png",
      width = 64,
      height = 64,
      priority = "medium"
    },
})

table.insert(createdEquipment.categories,trainWhistleEquipment)
createData("train-stop","train-stop",trainStopGhost,
{
	icon = "__"..ModName.."__/graphics/icons/empty.png",
    collision_box = {{0,0}, {0, 0}},
    selection_box = {{0,0}, {0, 0}}, 
})

local function emptyFileName(data)
	local newTable={}
	for key,value in pairs (data) do
		if type(value)=="table" then
			newTable[key]=emptyFileName(value)
		elseif key=="filename" and string.ends(value,"png") then
			newTable[key]="__"..ModName.."__/graphics/entity/empty.png"
		else
			newTable[key]=value
		end
	end
	return newTable
end
data.raw["train-stop"][trainStopGhost]=emptyFileName(data.raw["train-stop"][trainStopGhost])