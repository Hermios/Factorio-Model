rail_pictures = function()
  return rail_pictures_internal({{"metals", "metals", mipmap = true},
                                 {"backplates", "backplates", mipmap = true},
                                 {"ties", "ties", variations = 3},
                                 {"stone_path", "stone-path", variations = 3},
                                 {"stone_path_background", "stone-path-background", variations = 3}})
end

createData("locomotive","locomotive",hybridTrain,
{
	icon = "__RailPowerSystem__/graphics/entity/"..hybridTrain..".png",
	color = { r = 100, g = 100, b = 200 },
})

createData("electric-energy-interface","electric-energy-interface",railAccu,
{
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid"},
	collision_box = {{0, 0}, {0, 0}},
    selection_box = {{0, 0}, {0, 0}}, 
	energy_production = "0W",
    energy_usage = "0W",
	energy_source =
    {
      type = "electric",
      buffer_capacity = "11kJ",
      input_flow_limit = "15MJ",
      drain = "0J",
      usage_priority = "primary-input",
	  output_flow_limit = "15MJ",
    },
	picture =
    {
	  filename = "__RailPowerSystem__/graphics/entity/empty-small-electric-pole.png",
	  width = 123,
      height = 124,
      direction_count = 4,
      shift = {0, 0},
    },
	
}
)

createData("rail-signal","rail-signal",railPole,
{
	fast_replaceable_group = nil,
	selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    drawing_box = {{-0.5, -2.6}, {0.5, 0.5}},
	animation =
    {
      filename = "__RailPowerSystem__/graphics/entity/"..railPole..".png",
      priority = "high",
      line_length = 1,
      width = 123,
      height = 124,
      frame_count = 1,
	  direction_count = 8,
      shift = {0.7, -1.5},
    },
	circuit_connector_sprites=nil
}
)

createData("electric-pole","small-electric-pole",ghostElectricPole,
{
	icon = "__base__/graphics/icons/small-electric-pole.png",
    minable = {mining_time = 0.5, result = railPole},
	collision_box = {{0, 0}, {0, 0}},
    fast_replaceable_group = nil,
	eflags = {"placeable-neutral", "player-creation", "building-direction-8-way", "filter-directions", "fast-replaceable-no-build-while-moving"},
	supply_area_distance = 1,
	pictures ={
      filename = "__RailPowerSystem__/graphics/entity/"..ghostElectricPole..".png",
	  line_length = 1,
      width = 123,
      height = 124,
      direction_count = 1,
      shift = {0.7, -1.2}
    },
	track_coverage_during_build_by_moving = false,
	connection_points =
    {
      {
        shadow =
        {
          copper = {2.55, 0.4},
          green = {2.0, 0.4},
          red = {3.05, 0.4}
        },
        wire =
        {
          copper = {-0.03125, -2.46875},
          green = {-0.34375, -2.46875},
          red = {0.25, -2.46875}
        }
      },
    },
}
)

createData("electric-pole",ghostElectricPole,ghostElectricPoleNotSelectable,
{	
	minable= nil,	
	selectable_in_game=false,
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid"},
    drawing_box = {{0, 0}, {0, 0}},
	maximum_wire_distance =3.99, 
	pictures ={
      filename = "__RailPowerSystem__/graphics/entity/empty-small-electric-pole.png",
      line_length = 1,
      width = 123,
      height = 124,
      direction_count = 1,
      shift = {0, 0}
    },	
	connection_points =
    {
      {
        shadow =
        {
          copper = {0, 0},
          red = {0, 0},
          green = {0, 0}
        },
        wire =
        {
          copper = {0, 0},
          red = {0, 0},
          green = {0, 0}
        }
      },
	},
})	

createData("straight-rail","straight-rail",straightRailPower,
{		
	minable = {mining_time = 0.6, result = powerRail},
	pictures=rail_pictures(),
	corpse = "straight-rail-remnants",
})	

createData("curved-rail","curved-rail",curvedRailPower,
{		
	icon = "__base__/graphics/icons/curved-rail.png",
    minable = {mining_time = 0.6, result = powerRail, count=4},
	placeable_by = { item=powerRail, count = 4},
	pictures=rail_pictures(),
	corpse = "curved-rail-remnants",
})