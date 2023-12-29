-- Item
local item=createData("item","constant-combinator",
"ghost-constant-combinator",
{	
	flags = {"hidden"},
	icon ="__"..ModName.."__/graphics/empty.png",
})
--Entity
local local_activity_led_sprites=
{
filename="__"..ModName.."__/graphics/empty.png",
width=1,
height=1
}

local entity=createData("constant-combinator","constant-combinator","ghost-constant-combinator",
{
	icon="__"..ModName.."__/graphics/empty.png",
	collision_mask={"not-colliding-with-itself"},
	flags = {"placeable-neutral", "not-blueprintable","not-deconstructable"},
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
	}
})