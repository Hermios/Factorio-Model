--equipment categories
data:extend
  {
    {
      type = "equipment-category",
      name = "trainCaller-equipment"
    },
	{
      type = "equipment-grid",
      name = "trainCaller-equipment-grid",
      width = 2,
      height = 2,
      equipment_categories = {"trainCaller-equipment"},
    },
}

-- Equipment
local createdEquipment=createData("movement-bonus-equipment","exoskeleton-equipment",trainCallerEquipment,
{
	energy_consumption = "20W",
	movement_bonus = 0,
	sprite =
    {
      filename = "__"..ModName.."__/graphics/equipment/"..trainCallerEquipment..".png",
      width = 64,
      height = 64,
      priority = "medium"
    },
	shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
})

--Train stop signal receiver
circuit_connector_definitions[trainStopReceiver]=circuit_connector_definitions.create
(
  universal_connector_template,
  {
    { variation = 0, main_offset = util.by_pixel(0.2, 20), shadow_offset = util.by_pixel(0.2, 10), show_shadow = true },
    { variation = 1, main_offset = util.by_pixel(-0.1, 20), shadow_offset = util.by_pixel(-0.1, 10.2), show_shadow = true },
    { variation = 2, main_offset = util.by_pixel(0, 20), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
    { variation = 3, main_offset = util.by_pixel(0, 20), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
  }
)

createData("rail-signal","rail-signal",trainStopReceiver,
{
	icon="__TrainsCaller__/graphics/icons/empty.png",
	collision_box = {{0, 0}, {0, 0}},
	working_sound=nil,
	animation=nil,
	rail_piece=nil,
	green_light=nil,
	orange_light=nil,
	red_light=nil,
	circuit_wire_connection_points = circuit_connector_definitions[trainStopReceiver].points,
    circuit_connector_sprites = circuit_connector_definitions[trainStopReceiver].sprites,
	animation =
    {
      filename = "__TrainsCaller__/graphics/entity/trainStopReceiver.png",
      priority = "high",
      width = 64,
      height = 74,
      frame_count = 1,
      direction_count = 4,
      hr_version =
      {
        filename = "__TrainsCaller__/graphics/entity/trainStopReceiver.png",
        priority = "high",
        width = 64,
        height = 74,
        frame_count = 1,
        direction_count = 4,
        scale = 0.5
      }
    },
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	flags = {"not-on-map","placeable-off-grid","not-blueprintable","not-deconstructable"},
})

table.insert(createdEquipment.categories,"trainCaller-equipment")