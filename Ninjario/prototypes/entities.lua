local function invisibleVehicleRecursiveCopy(oldTable)
	local newTable={}
	for k,d in pairs(oldTable) do
		if not d then
			newTable[k]=nil
		elseif type(d)=="table" then
			if k=="filenames" and d[1] and type(d[1])=="string" and string.find(d[1],"entity") and not string.find(d[1],"mask") and not string.find(d[1],"shadow") then
				newTable[k]={}
				for i=1,#d do
					table.insert(newTable[k],"__"..ModName.."__/graphics/entity/empty.png")
				end
			else
				newTable[k]=invisibleVehicleRecursiveCopy(d) 
			end
		elseif type(d)=="string" then
			newTable[k]=d
			if k=="filename" and string.find(d,"entity") and not string.find(d,"mask") and not string.find(d,"shadow") then
				newTable[k]="__"..ModName.."__/graphics/entity/empty.png"
			end
		else
			newTable[k]=d
		end
	end
	return newTable
end

local createInvisibleVehicleData=function(objectType,original,newName)
	local newTable=table.deepcopy(data.raw[objectType][original])
	newTable.name=newName
	local newEntity=invisibleVehicleRecursiveCopy(newTable)
	data:extend({newEntity})
	return newEntity
end

--equipment categories
data:extend
  {
    {
      type = "equipment-category",
      name = invisibleEquipment
    },
	{
      type = "equipment-grid",
      name = "invisible-equipment-grid",
      width = 2,
      height = 2,
      equipment_categories = {invisibleEquipment},
    },
}

-- Equipment
local createdEquipment=createData("movement-bonus-equipment","exoskeleton-equipment",invisibleEquipment,
{
	energy_consumption = "5MW",
	movement_bonus = 0,
	shape =
    {
      width = 5,
      height = 5,
      type = "full"
    },
})

-- invisible player
--[[createData("player","player",invisiblePlayer,
{
	icon="__base__/graphics/icons/player.png",
	animations =
    {
      {
        idle =
        {
          layers =
          {
            playeranimations.level1.idle_mask,
            playeranimations.level1.idle_shadow
          }
        },
        idle_with_gun =
        {
          layers =
          {
            playeranimations.level1.idle_gun_mask,
            playeranimations.level1.idle_gun_shadow
          }
        },
        mining_with_hands =
        {
          layers =
          {
            playeranimations.level1.mining_hands_mask,
            playeranimations.level1.mining_hands_shadow
          }
        },
        mining_with_tool =
        {
          layers =
          {
			playeranimations.level1.mining_tool_mask,
            playeranimations.level1.mining_tool_shadow
          }
        },
        running_with_gun =
        {
          layers =
          {
            playeranimations.level1.running_gun_mask,
            playeranimations.level1.running_gun_shadow
          }
        },
        running =
        {
          layers =
          {
            playeranimations.level1.running_mask,
            playeranimations.level1.running_shadow
          }
        }
      },
      {
        idle =
        {
          layers =
          {
            playeranimations.level1.idle_mask,
            playeranimations.level2addon.idle_mask,
            playeranimations.level1.idle_shadow
          }
        },
        idle_with_gun =
        {
          layers =
          {
            playeranimations.level1.idle_gun_mask,
            playeranimations.level2addon.idle_gun_mask,
            playeranimations.level1.idle_gun_shadow
          }
        },
        mining_with_hands =
        {
          layers =
          {
            playeranimations.level1.mining_hands_mask,
            playeranimations.level2addon.mining_hands_mask,
            playeranimations.level1.mining_hands_shadow
          }
        },
        mining_with_tool =
        {
          layers =
          {
            playeranimations.level1.mining_tool_mask,
            playeranimations.level2addon.mining_tool_mask,
            playeranimations.level1.mining_tool_shadow
          }
        },
        running_with_gun =
        {
          layers =
          {
            playeranimations.level1.running_gun_mask,
            playeranimations.level2addon.running_gun_mask,
            playeranimations.level1.running_gun_shadow
          }
        },
        running =
        {
          layers =
          {
            playeranimations.level1.running_mask,
            playeranimations.level2addon.running_mask,
            playeranimations.level1.running_shadow
          }
        }
      },
      {
        idle =
        {
          layers =
          {
            playeranimations.level1.idle_mask,
            playeranimations.level3addon.idle_mask,
            playeranimations.level1.idle_shadow
          }
        },
        idle_with_gun =
        {
          layers =
          {
            playeranimations.level1.idle_gun_mask,
            playeranimations.level3addon.idle_gun_mask,
            playeranimations.level1.idle_gun_shadow
          }
        },
        mining_with_hands =
        {
          layers =
          {
            playeranimations.level1.mining_hands_mask,
            playeranimations.level3addon.mining_hands_mask,
            playeranimations.level1.mining_hands_shadow
          }
        },
        mining_with_tool =
        {
          layers =
          {
            playeranimations.level1.mining_tool_mask,
            playeranimations.level3addon.mining_tool_mask,
            playeranimations.level1.mining_tool_shadow
          }
        },
        running_with_gun =
        {
          layers =
          {
            playeranimations.level1.running_gun_mask,
            playeranimations.level3addon.running_gun_mask,
            playeranimations.level1.running_gun_shadow
          }
        },
        running =
        {
          layers =
          {
            playeranimations.level1.running_mask,
            playeranimations.level3addon.running_mask,
            playeranimations.level1.running_shadow
          }
        }
      }
    },
})

--invisible vehicles
createInvisibleVehicleData("car","car",invisibleCar)

createInvisibleVehicleData("car","tank",invisibleTank)

createInvisibleVehicleData("locomotive","locomotive",invisibleLocomotive)

createInvisibleVehicleData("cargo-wagon","cargo-wagon",invisibleCargoWagon)

createInvisibleVehicleData("fluid-wagon","fluid-wagon",invisibleFluidWagon)

createInvisibleVehicleData("artillery-wagon","artillery-wagon",invisibleArtilleryWagon)]]--

table.insert(createdEquipment.categories,invisibleEquipment)
