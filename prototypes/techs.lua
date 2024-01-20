data:extend(
{
  {
    type = "technology",
    name = tech,
    icon = "__"..modname.."__/graphics/technology/tech.png",
	  icon_size=128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = recipe
      },
    },
  prerequisites = {},
    unit =
    {
      count = ,
      ingredients =
      {
        {, },
      },
      time = 
    }
  }
})