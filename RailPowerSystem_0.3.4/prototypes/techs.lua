data:extend(
{
  {
    type = "technology",
    name = "rail-power-system",
    icon = "__"..ModName.."__/graphics/tech/tech.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = hybridTrain
      },
      {
        type = "unlock-recipe",
        recipe = prototypeConnector
      },
      {
        type = "unlock-recipe",
        recipe = electricRail
      }
    },
	icon_size=128,
    prerequisites = {"circuit-network","railway"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 15
    },
    order = "a-d-d",
  }
})