require "constants"

data:extend(
{
  {
    type = "technology",
    name = "rail-power-system",
    icon = "__RailPowerSystem__/graphics/tech/tech.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = hybridTrain
      },
      {
        type = "unlock-recipe",
        recipe = railPole
      },
      {
        type = "unlock-recipe",
        recipe = powerRail
      }
    },
	icon_size=128,
    prerequisites = {"circuit-network","railway"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})