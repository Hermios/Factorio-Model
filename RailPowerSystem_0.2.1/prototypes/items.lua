--train
createData("item-with-entity-data","locomotive",hybridTrain)

--circuit's components
createData("item","rail-signal",prototypeConnector)

createData("item","small-electric-pole",railPoleConnector,
{
	icon = "__"..ModName.."__/graphics/icons/empty.png",
	subgroup = "transport",
	flags = {"hidden"},
	order = "zzz",
})

createData("item",railPoleConnector,circuitNode)

createData("item",railPoleConnector,railElectricAccu)

--rail
createData("rail-planner","rail",electricRail,
{ 
	flags = {"goes-to-quickbar"},
	subgroup = "transport",
	place_result = electricStraightRail,
	straight_rail = electricStraightRail,
	curved_rail = electricCurvedRail
})
