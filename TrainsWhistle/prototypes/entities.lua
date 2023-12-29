-- Equipment
createData("movement-bonus-equipment","exoskeleton-equipment",trainWhistleEquipment,
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
	categories={"locomotive-category"}
})

createData("train-stop","train-stop",trainStopGhost)
data.raw["train-stop"][trainStopGhost]=setEntityAsInvisible(data.raw["train-stop"][trainStopGhost])
