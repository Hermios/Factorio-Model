createData("item","exoskeleton-equipment",trainWhistleEquipment,
{
	subgroup = "transport",
	order = "a[train-system]-e["..trainWhistleEquipment.."]",	
})

createData("item","train-stop",trainStopGhost,
{
	icon = "__"..ModName.."__/graphics/icons/empty.png",
	subgroup = "transport",
	flags = {"hidden"},
	order = "zzz",
}
)