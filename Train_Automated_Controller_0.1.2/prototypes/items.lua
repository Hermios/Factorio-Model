--circuit's components
createData("item","train-stop",TACPrototype)

createData("item","decider-combinator",InputTAC,
{
	icon = "__"..ModName.."__/graphics/icons/empty.png",
	subgroup = "transport",
	flags = {"hidden"},
	order = "zzz",
})

createData("item",InputTAC,OutputTAC)