createData("item","exoskeleton-equipment",trainCallerEquipment,
{
	subgroup = "transport",
	order = "a[train-system]-e["..trainCallerEquipment.."]",	
})

createData("item","arithmetic-combinator",trainStopReceiver,
{
	icon = "__TrainsCaller__/graphics/icons/empty.png",
	subgroup = "transport",
	flags = {"hidden"},
	order = "zzz",	
})