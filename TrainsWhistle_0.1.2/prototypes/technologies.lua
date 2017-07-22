data:extend(
{
  {
    type = "technology",
    name = trainWhistleTech,
    icon = "__"..ModName.."__/graphics/tech.png",
	icon_size=128,
    prerequisites = {"circuit-network","automated-rail-transportation","construction-robotics"},
	effects =
    {
      {
        type = "unlock-recipe",
        recipe = trainWhistleEquipment
      },
    },
    unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
		{"science-pack-3", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})