require "constants"
require "localData"
require "libs.dataLibs"
require "events.globalEvents"
require "methods.dataBuilder"
require "methods.railMethods"
require "methods.trainMethods"
require "methods.remoteBuilder"
init=false

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
	InitDataLibs()
	InitData()
	init=true
end
	OnTick()
end)