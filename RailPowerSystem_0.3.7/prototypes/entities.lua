function update_rail_picture_metals(data)
	local newTable={}
	for k,d in pairs(data) do
		if not d then
			newTable[k]=nil
		elseif type(d)=="table" then
			newTable[k]=update_rail_picture_metals(d) 
		elseif type(d)=="string" and k=="filename" and string.find(d,"__base__/graphics/entity/%w+-rail/[%w%-]+backplates.+") then
			newTable[k]=d
			print("OK")
			newTable[k]=string.gsub(newTable[k],"__%a-__/(.+)","__"..ModName.."__/%1")			 			
		else
			newTable[k]=d
		end
	end
	return newTable 
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
    draw_copper_wires=false,
	draw_circuit_wires=false,
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
	draw_copper_wires=false,
	draw_circuit_wires=false,
	selectable_in_game=false,
	collision_mask={"not-colliding-with-itself"},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
	maximum_wire_distance =3.99, 
	supply_area_distance =0.5
})	
setEntityAsInvisible(data.raw["electric-pole"][circuitNode])

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
local electricStraightRailEntity=createData("straight-rail","straight-rail",electricStraightRail,
{		
	minable = {mining_time = 0.6, result = electricRail},
	corpse = "straight-rail-remnants",
})	
print("START")
data.raw["straight-rail"][electricStraightRail]=update_rail_picture_metals(electricStraightRailEntity)
print("END")
local electricCurvedRailEntity=createData("curved-rail","curved-rail",electricCurvedRail,
{		
	icon = "__base__/graphics/icons/curved-rail.png",
    minable = {mining_time = 0.6, result = electricRail, count=4},
	placeable_by = { item=electricRail, count = 4},
	corpse = "curved-rail-remnants",
})

data.raw["curved-rail"][electricCurvedRail]=update_rail_picture_metals(electricCurvedRailEntity)