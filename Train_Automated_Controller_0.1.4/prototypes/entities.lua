--circuit's components
--Input TAC
createData("train-stop","train-stop",TACPrototype,
{
	collision_box = {{0, 0}, {0, 0}},
    selection_box = {{0, 0}, {0, 0}},
	corpse = "train-stop-remnants",
	rail_overlay_animations = make_4way_animation_from_spritesheet(
    {
      filename = "__"..ModName.."__/graphics/entity/empty.png",
      line_length = 4,
      width = 1,
      height = 1,
      direction_count = 4,
    }),
	animations = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__"..ModName.."__/graphics/entity/combinator/InputTAC.png",
        line_length = 4,
        width = 194,
        height = 189,
        direction_count = 4,
          hr_version =
          {
            filename = "__"..ModName.."__/graphics/entity/combinator/InputTAC.png",
            line_length = 4,
            width = 194,
            height = 189,
            direction_count = 4,
            scale = 0.5
          }
      },
    }}),
	top_animations = make_4way_animation_from_spritesheet({ layers =
    {
      {
        filename = "__"..ModName.."__/graphics/entity/empty.png",
        line_length = 4,
        width = 1,
        height = 1,
        direction_count = 4,
      },
    }}),
	
})

createData("decider-combinator","decider-combinator",InputTAC,
{
	flags = {"placeable-off-grid"},
	minable = {hardness = 0.2, mining_time = 0.5, result = TACPrototype},
	active_energy_usage = "10KW",
	sprites=make_4way_animation_from_spritesheet({ layers =
      {
        {
			filename = "__"..ModName.."__/graphics/entity/empty.png",
			line_length = 4,
			width = 1,
			height = 1,
			direction_count = 4,
			hr_version =
			{
				filename = "__"..ModName.."__/graphics/entity/empty.png",
				line_length = 4,
				width = 1,
				height = 1,
				direction_count = 4,
			}
		},
      }
    }),
	less_symbol_sprites=
	{
		north =
		{
			filename = "__"..ModName.."__/graphics/entity/empty.png",
			x = 1,
			y = 1,
			width = 1,
			height = 1
		},
		east =
		{
			filename = "__"..ModName.."__/graphics/entity/empty.png",
			x = 1,
			y = 1,
			width = 1,
			height = 1
		},
		west =
		{
			filename = "__"..ModName.."__/graphics/entity/empty.png",
			x = 1,
			y = 1,
			width = 1,
			height = 1
		},
		south =
		{
			filename = "__"..ModName.."__/graphics/entity/empty.png",
			x = 1,
			y = 1,
			width = 1,
			height = 1
		},
	},
	
	input_connection_points =
    {
      {--east
        shadow =
        {
          red = {0.328125, 0.703125},
          green = {0.859375, 0.703125}
        },
        wire =
        {
          red = {-0.415, 0.548},
          green = {0.105, 0.548}
        }
      },
      {--south
        shadow =
        {
          red = {-0.265625, -0.771875},
          green = {-0.796875, 0.296875}
        },
        wire = 
        {
          red = {-0.499, -0.03},
          green = {-0.499, 0.475}
        }
      },
      {--west
        shadow =
        {
          red = {0.828125, -0.359375},
          green = {0.234375, -0.359375}
        },
        wire =
        {
          red = {0.25, -0.71875},
          green = {-0.28125, -0.71875}
        }
      },
      {--north
        shadow =
        {
          red = {0.27688, 0.728125},
          green = {0.09688, 0.140625}
        },
        wire =
        {
          red = {0.475, 0.188},
          green = {0.475, 0.62}
        }
      }
    },
	output_connection_points =
    {
      {--east
        shadow =
        {
          red = {0.234375, -0.453125},
          green = {0.828125, -0.453125}
        },
        wire =
        {
          red = {-0.5, -0.4},
          green = {0.15, -0.4}
        }
      },
      {--south
        shadow =
        {
          red = {1.17188, -0.109375},
          green = {1.17188, 0.296875}
        },
        wire =
        {
          red = {0.57, 0},
          green = {0.57, 0.5}
        }
      },
      {--west
        shadow =
        {
          red = {0.828125, 0.765625},
          green = {0.234375, 0.765625}
        },
        wire =
        {
          red = {0.28125, 0.35},
          green = {-0.3125, 0.35}
        }
      },
      {--north
        shadow =
        {
          red = {-0.140625, 0.328125},
          green = {-0.140625, -0.078125}
        },
        wire =
        {
          red = {-0.76, 0.29},
          green = {-0.76, 0.7}
        }
      }
    },
})

--Entity
local local_activity_led_sprites=
{
filename="__"..ModName.."__/graphics/entity/empty.png",
width=1,
height=1
}

local entity=createData("constant-combinator","constant-combinator",OutputTAC,
{
	icon="__"..ModName.."__/graphics/entity/empty.png",
	collision_mask={"not-colliding-with-itself"},
	flags = {"placeable-off-grid", "not-blueprintable","not-deconstructable"},
	item_slot_count=40,
	collision_box = {{0, 0}, {0, 0}},
    selection_box = {{0, 0}, {0, 0}},
	minable={mining_time=0,result=nil},
	sprites=
	{
		north=local_activity_led_sprites,
		east=local_activity_led_sprites,
		west=local_activity_led_sprites,
		south=local_activity_led_sprites
	},
	activity_led_sprites=
	{
		north=local_activity_led_sprites,
		east=local_activity_led_sprites,
		west=local_activity_led_sprites,
		south=local_activity_led_sprites
	},
	circuit_wire_connection_points =
	{
      {--east
        shadow =
        {
          red = {0.234375, -0.453125},
          green = {0.828125, -0.453125}
        },
        wire =
        {
          red = {-0.5, -0.4},
          green = {0.15, -0.4}
        }
      },
      {--south
        shadow =
        {
          red = {1.17188, -0.109375},
          green = {1.17188, 0.296875}
        },
        wire =
        {
          red = {0.57, 0},
          green = {0.57, 0.5}
        }
      },
      {--west
        shadow =
        {
          red = {0.828125, 0.765625},
          green = {0.234375, 0.765625}
        },
        wire =
        {
          red = {0.28125, 0.35},
          green = {-0.3125, 0.35}
        }
      },
      {--north
        shadow =
        {
          red = {-0.140625, 0.328125},
          green = {-0.140625, -0.078125}
        },
        wire =
        {
          red = {-0.76, 0.29},
          green = {-0.76, 0.7}
        }
      }
    },
})