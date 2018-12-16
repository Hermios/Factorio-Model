
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
        {"science-pack-1", 1},
        {"science-pack-2", 1},
		{"science-pack-3", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})