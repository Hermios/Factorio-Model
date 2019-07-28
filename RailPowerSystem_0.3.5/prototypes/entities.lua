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
	icon = "__"..ModName.."__/graphics/icons/"..hybridTrain..".png",
	color = { r = 100, g = 100, b = 200 },
})

--circuit's components
createData("rail-signal","rail-signal",prototypeConnector,
{
	fast_replaceable_group = nil,
	selection_box={{0, 0}, {0, 0}},
    drawing_box = {{-0.5, -2.6}, {0.5, 0.5}},
	corpse = "rail-signal-remnants",
    animation =
    {
		filename="__"..ModName.."__/graphics/entity/"..railPoleConnector..".png",
		priority = "high",
		width = 189,
		height = 160,
		frame_count = 1,
		direction_count = 8
    },
	green_light = {intensity = 0, size = 0.1, color={g=1}},
    orange_light = {intensity = 0, size = 0.1, color={r=1, g=0.5}},
    red_light = {intensity = 0, size = 0.1, color={r=1}},
	circuit_connector_sprites=nil
})

createData("electric-pole","small-electric-pole",railPoleConnector,
{
	icon = "__base__/graphics/icons/small-electric-pole.png",
    minable = {mining_time = 0.5, result = prototypeConnector},
	collision_box = {{0, 0}, {0, 0}},
	fast_replaceable_group = nil,
	corpse="small-electric-pole-remnants",
	flags = {"placeable-neutral", "player-creation","not-blueprintable","fast-replaceable-no-build-while-moving","placeable-off-grid","building-direction-8-way"},
	supply_area_distance = 1,
	pictures ={
		filename="__"..ModName.."__/graphics/entity/"..railPoleConnector..".png",
		priority = "high",
		line_length = 1,
		width = 189,
		height = 160,
		direction_count = 8
    },
	track_coverage_during_build_by_moving = false,
	connection_points =
    {
      {
        shadow =
        {
           copper = nil,
          green = nil,
          red = nil
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
          copper = nil,
          green = nil,
          red = nil,
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
           copper = nil,
          green = nil,
          red = nil,
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
           copper = nil,
          green = nil,
          red = nil,
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
          copper = nil,--{2.55, 0.4},
          green = nil,--{2.0, 0.4},
          red = nil,--{3.05, 0.4}
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
          copper = nil,
          green = nil,
          red = nil,
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
        {
           copper = nil,
          green = nil,
          red = nil,
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
        }
      },
	  {
        shadow =
      {
          copper = nil,--{2.55, 0.4},
          green = nil,--{2.0, 0.4},
          red = nil,--{3.05, 0.4}
        },
        wire =
        {
          copper = {0, -1.9},
          green = {0, -1.9},
          red = {0, -1.9}
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
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
	maximum_wire_distance =3.99, 
	supply_area_distance =0.5
})	
data.raw["electric-pole"][circuitNode]=setEntityAsInvisible(data.raw["electric-pole"][circuitNode])

createData("electric-energy-interface","electric-energy-interface",railElectricAccu,
{
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
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
	working_sound =
    {
      sound =
      {
        filename = "__base__/sound/accumulator-working.ogg",
        volume = 0
      },
      idle_sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0
      }
	}
})
setEntityAsInvisible(data.raw["electric-energy-interface"][railElectricAccu])

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