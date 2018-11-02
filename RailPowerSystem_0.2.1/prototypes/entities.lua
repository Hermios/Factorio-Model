rail_pictures = function()
  return rail_pictures_internal({{"metals", "metals", mipmap = true},
                                 {"backplates", "backplates", mipmap = true},
                                 {"ties", "ties", variations = 3},
                                 {"stone_path", "stone-path", variations = 3},
                                 {"stone_path_background", "stone-path-background", variations = 3}})
end

--train
createData("locomotive","locomotive",hybridTrain,
{
	color = { r = 100, g = 100, b = 200 },
})

--circuit's components
createData("rail-signal","rail-signal",prototypeConnector,
{
	fast_replaceable_group = nil,
	selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    drawing_box = {{-0.5, -2.6}, {0.5, 0.5}},
	animation =
    {
		filename="__"..ModName.."__/graphics/entity/"..railPoleConnector..".png",
		priority = "high",
		line_length = 1,
		width = 123,
		height = 124,
		frame_count = 1,
		direction_count = 8,
		shift = {0.7, -1.5},
    },
	circuit_connector_sprites=nil
})

createData("electric-pole","small-electric-pole",railPoleConnector,
{
	icon = "__base__/graphics/icons/small-electric-pole.png",
    minable = {mining_time = 0.5, result = prototypeConnector},
	collision_box = {{0, 0}, {0, 0}},
    fast_replaceable_group = nil,
	eflags = {"placeable-neutral", "player-creation", "building-direction-8-way", "filter-directions", "fast-replaceable-no-build-while-moving","placeable-off-grid"},
	supply_area_distance = 1,
	pictures ={
		filename="__"..ModName.."__/graphics/entity/"..railPoleConnector..".png",
		line_length = 1,
		width = 123,
		height = 124,
		direction_count = 8,
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

createData("electric-pole",railPoleConnector,circuitNode,
{	
	minable= nil,	
	selectable_in_game=false,
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid"},
    drawing_box = {{0, 0}, {0, 0}},
	maximum_wire_distance =3.99, 
	pictures ={
      filename = "__"..ModName.."__/graphics/entity/empty.png",
	  line_length = 1,
      width = 1,
      height = 1,
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

createData("electric-energy-interface","electric-energy-interface",railElectricAccu,
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
	  filename = "__"..ModName.."__/graphics/entity/empty.png",
	  width = 1,
      height = 1,
      direction_count = 1,
      shift = {0, 0},
    },
	working_sound =nil
})
--rail
createData("straight-rail","straight-rail",electricStraightRail,
{		
	minable = {mining_time = 0.6, result = electricRail},
	pictures=rail_pictures(),
	corpse = "straight-rail-remnants",
})	

createData("curved-rail","curved-rail",electricCurvedRail,
{		
	icon = "__base__/graphics/icons/curved-rail.png",
    minable = {mining_time = 0.6, result = electricRail, count=4},
	placeable_by = { item=electricRail, count = 4},
	pictures=rail_pictures(),
	corpse = "curved-rail-remnants",
})