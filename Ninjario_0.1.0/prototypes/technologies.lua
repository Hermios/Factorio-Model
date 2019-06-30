data:extend(
{
  {
    type = "technology",
    name = technologyName,
    icon = "__"..ModName.."__/graphics/tech.png",
	icon_size=128,
    prerequisites = {"circuit-network","automated-rail-transportation","construction-robotics"},
	effects =
    {
      {
        type = "unlock-recipe",
        recipe = invisibleEquipment
      },
    },
    unit =
    {
      count = 500,
      ingredients =
      {
		{"automation-science-pack", 1},
        {"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
        {"military-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})