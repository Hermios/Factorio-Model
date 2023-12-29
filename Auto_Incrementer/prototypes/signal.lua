data:extend(
{
	{
    type = "item-subgroup",
    name = "autoIncrementSignals",
    group = "signals",
    order = "d"
  },
  {
    type = "virtual-signal",
    name = AicSignal,
    icon = "__"..ModName.."__/graphics/icons/"..AicSignal..".png",
    icon_size = 32,
    subgroup = "autoIncrementSignals",
    order = "a-a"
  }
})