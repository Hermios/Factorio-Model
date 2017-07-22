--equipment categories
data:extend
  {
    {
      type = "equipment-category",
      name = "trainCaller-equipment"
    },
	{
      type = "equipment-grid",
      name = "trainCaller-equipment-grid",
      width = 2,
      height = 2,
      equipment_categories = {"trainCaller-equipment"},
    },
}

-- Equipment
local createdEquipment=createData("movement-bonus-equipment","exoskeleton-equipment",trainCallerEquipment,
{
	energy_consumption = "20W",
	movement_bonus = 0,
	shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
})

table.insert(createdEquipment.categories,"trainCaller-equipment")
