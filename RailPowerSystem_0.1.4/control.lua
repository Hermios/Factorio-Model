require "constants"
require "libs.dataLibs"
require "libs.railPowerLib"
require "libs.eventsHandler"
require "controls.rail"
require "controls.train"
require "methods.remoteBuilder"
init=false
script.on_init(function(event)
	OnLoad()
end)

script.on_load(function (event)
	OnLoad()
end)

--build
script.on_event(defines.events.on_robot_built_entity, function(event)
	OnBuildEntity(event.created_entity)
end)

script.on_event(defines.events.on_built_entity, function(event)
	OnBuildEntity(event.created_entity)
end)

--premined
script.on_event(defines.events.on_robot_pre_mined, function(event)
	OnPreRemoveEntity(event.entity)
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	OnPreRemoveEntity(event.entity)
end)

--tick
script.on_event(defines.events.on_tick,function(event)
if not init then
	if remote.interfaces.farl then
		remote.call("farl", "add_entity_to_trigger", straightRailPower)
		remote.call("farl", "add_entity_to_trigger", curvedRailPower)
	end
	init=true
end
	OnTick()
end)