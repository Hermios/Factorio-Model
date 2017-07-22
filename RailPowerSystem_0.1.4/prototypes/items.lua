createData("rail-planner","rail",powerRail,
{ 
	flags = {"goes-to-quickbar"},
	subgroup = "transport",
	place_result = straightRailPower,
	straight_rail = straightRailPower,
	curved_rail = curvedRailPower
})
createData("item","small-electric-pole",railPole)
createData("item",railPole,ghostElectricPole,
{
	icon = "__RailPowerSystem__/graphics/icons/empty.png",
	subgroup = "transport",
	flags = {"hidden"},
	order = "zzz",
})
createData("item",ghostElectricPole,ghostElectricPoleNotSelectable)
createData("item",ghostElectricPoleNotSelectable,railAccu)
createData("item-with-entity-data","locomotive",hybridTrain,
{
	icon = "__RailPowerSystem__/graphics/icons/"..hybridTrain..".png",
}
)