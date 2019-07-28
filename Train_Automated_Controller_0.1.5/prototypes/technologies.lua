data:extend(
{
  {
    type = "technology",
    name = technologyName,
    icon = "__"..ModName.."__/graphics/tech/tech.png",
	icon_size=128,
    prerequisites = {"advanced-electronics-2","automated-rail-transportation","circuit-network"},
	effects =
    {
      {
        type = "unlock-recipe",
        recipe = TACRecipe
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
        {"production-science-pack", 1},
        {"utility-science-pack", 1}        
      },
      time = 15
    },
    order = "a-d-d",
  }
})