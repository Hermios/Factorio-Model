
data:extend(
{
  {
    type = "technology",
    name = technologyName,
    icon = "__"..ModName.."__/graphics/tech.png",
	icon_size=128,
    prerequisites = {"circuit-network","automated-rail-transportation"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
		{"chemical-science-pack", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})