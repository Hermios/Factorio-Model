require "libs.dataLibs"
require "libs.guiLibs"
require "libs.logging"
require "libs.signalLibs"
require "constants"
require "localData"
require "methods.DebugMethods"
require "events.globalEvents"
require "events.guiFrameEvents"
require "events.guiElementEvents"
initialized=false

---------------------------------------------------
--tick
---------------------------------------------------
script.on_event(defines.events.on_tick, function(event)
	if not initialized then
		InitDataLibs()
		InitGuiLibs()
		InitSignalLib()
		InitData()
		initialized=true
	end
	openGui()
end)

---------------------------------------------------
-- On train state changed
---------------------------------------------------
script.on_event(defines.events.on_train_changed_state, function(event)
	if OnTrainStateChanged then
		OnTrainStateChanged(event.train)
	end
end)

---------------------------------------------------
-- On entity built
---------------------------------------------------
script.on_event(defines.events.on_robot_built_entity, function(event)
	if entities[event.created_entity.name] and entities[event.created_entity.name].OnBuilt then
		entities[event.created_entity.name].OnBuilt(event.created_entity)
	end	
end)

script.on_event(defines.events.on_built_entity, function(event)
	if entities[event.created_entity.name] and entities[event.created_entity.name].OnBuilt then
		entities[event.created_entity.name].OnBuilt(event.created_entity)
	end	
end)

script.on_event(defines.events.on_train_created, function(event)
	if OnTrainBuilt then
		OnTrainBuilt(event.train)
	end	
end)

---------------------------------------------------
-- On entity removed
---------------------------------------------------
script.on_event(defines.events.on_robot_pre_mined, function(event)
	if entities[event.entity.name] and entities[event.entity.name].OnRemoved then
		entities[event.entity.name].OnRemoved(event.entity)
	end	
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if entities[event.entity.name] and entities[event.entity.name].OnRemoved then
		entities[event.entity.name].OnRemoved(event.entity)
	end	
end)

script.on_event(defines.events.on_entity_died, function(event)
	if entities[event.entity.name] and entities[event.entity.name].OnRemoved then
		entities[event.entity.name].OnRemoved(event.entity)
	end	
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
-- On gui checked state changed
---------------------------------------------------
script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	local name=getElementNameFromEvent(event)
	if not name or not OnUpdateFromGui then
		return
	end	
	OnUpdateFromGui()
end)
---------------------------------------------------
-- On gui clicked
---------------------------------------------------
script.on_event(defines.events.on_gui_click, function(event)
	local name=getElementNameFromEvent(event)
	if not name then
		return
	end	
	if guiElementEntities[name] and guiElementEntities[name].OnGuiClicked then
		guiElementEntities[name].OnGuiClicked(player.opened,event.element)
	end
end)

---------------------------------------------------
-- On gui selection state changed
---------------------------------------------------
script.on_event(defines.events.on_gui_selection_state_changed, function(event)
	local name=getElementNameFromEvent(event)
	if not name then
		return
	end	
	if guiElementEntities[name] and guiElementEntities[name].OnGuiSelectionStateChanged then
		guiElementEntities[name].OnGuiSelectionStateChanged(player.opened,event.element)
	end
end)

---------------------------------------------------
-- On gui text changed
---------------------------------------------------
script.on_event(defines.events.on_gui_text_changed, function(event)
	local name=getElementNameFromEvent(event)
	if not name then
		return
	end	
	if guiElementEntities[name] and guiElementEntities[name].OnChangedText then
		guiElementEntities[name].OnChangedText(player.opened,event.element)
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
--On research finished
---------------------------------------------------
script.on_event(defines.events.on_research_finished, function(event)
end)