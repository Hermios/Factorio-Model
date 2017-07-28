require "constants"
require "localData"
require "libs.dataLibs"
require "libs.logging"
require "events.globalEvents"
local initialized=false
	
---------------------------------------------------
--tick
---------------------------------------------------
script.on_event(defines.events.on_tick, function(event)
	if not initialized then
		InitDataLibs()
		trainEntity.table=global.trains
		initialized=true
	end
end)

---------------------------------------------------
--On train created
---------------------------------------------------
script.on_event(defines.events.on_train_created, function(event)
	OnTrainCreated(event.train)
end)

---------------------------------------------------
-- On entity removed
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, function(event)
	if entities[event.entity.type] and entities[event.entity.type].OnRemoved then
		entities[event.entity.type].OnRemoved(event.entity)
	end	
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if entities[event.entity.type] and entities[event.entity.type].OnRemoved then
		entities[event.entity.type].OnRemoved(event.entity)
	end	
end)
---------------------------------------------------
--On train state changed
---------------------------------------------------
script.on_event(defines.events.on_train_changed_state, function(event)
	OnStateChanged(event.train)
end)

---------------------------------------------------
-- On equipment placed
---------------------------------------------------
script.on_event(defines.events.on_player_placed_equipment, function(event)
	if entities[event.equipment.name] and entities[event.equipment.name].OnEquipmentPlaced then
		entities[event.equipment.name].OnEquipmentPlaced(event.equipment)
	end	
end)

---------------------------------------------------
-- On equipment removed
---------------------------------------------------
script.on_event(defines.events.on_player_removed_equipment, function(event)	
	if entities[event.equipment] and entities[event.equipment].OnEquipmentRemoved then
		entities[event.equipment].OnEquipmentRemoved(event.equipment)
	end
end)

---------------------------------------------------
--On research finished
---------------------------------------------------
script.on_event(defines.events.on_research_finished, function(event)
	if event.research.name==trainWhistleTech then
		global.trains={}
	end
end)

---------------------------------------------------
-- On copy paste
---------------------------------------------------
script.on_event(defines.events.on_pre_entity_settings_pasted, function(event)
	if event.source.type==event.destination.type and entities[event.destination.type] and entities[event.destination.type].table then
		if event.destination.type=="locomotive" then
			entities[event.destination.type].table[event.destination.train.id]=entities[event.destination.type].table[event.source.train.id]
		else
			entities[event.destination.type].table[event.destination.unit_number]=entities[event.destination.type].table[event.source.unit_number]
		end
	end
end)

---------------------------------------------------
--On Control toggled
---------------------------------------------------
script.on_event(whistleTrainControl,function(event)
	if not player.selected then
	return
	end
	local selType=player.selected.type
	if entities[selType] and entities[selType].OnWhilsteDo then
		entities[selType].OnWhilsteDo(event)
	end
end)