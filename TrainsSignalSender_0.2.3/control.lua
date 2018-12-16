listCustomEvents={}
eventsControl={}
require "libs.dataLibs"
require "libs.guiLibs"
require "libs.entityLibs"
require "debug.logging"
require "methods.constants"
require "methods.initialisation"

local initialized=false

---------------------------------------------------
--tick
---------------------------------------------------
script.on_event(defines.events.on_tick, function(event)
	if not initialized then
		if InitDataLibs then InitDataLibs() end
		if InitGuiLibs then InitGuiLibs() end
		if InitGlobalData then InitGlobalData() end
		if InitGuiBuild then InitGuiBuild() end
		if InitCommands then InitCommands() end
		if InitRemote then InitRemote() end
		if InitData then InitData() end
		if InitCustomEvents then InitCustomEvents() end
		initialized=true
	end
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if OnTick then OnTick() end
end)

---------------------------------------------------
-- ENTITY
---------------------------------------------------
-- On entity built
script.on_event(defines.events.on_robot_built_entity, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if eventsControl[event.created_entity.type] and eventsControl[event.created_entity.type].OnBuilt then
		eventsControl[event.created_entity.type].OnBuilt(event.created_entity)
	elseif eventsControl["any"] and eventsControl["any"].OnBuilt then
		eventsControl["any"].OnBuilt(event.created_entity)
	end	
end)

script.on_event(defines.events.on_built_entity, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if eventsControl[event.created_entity.type] and eventsControl[event.created_entity.type].OnBuilt then
		eventsControl[event.created_entity.type].OnBuilt(event.created_entity)
	elseif eventsControl["any"] and eventsControl["any"].OnBuilt then
		eventsControl["any"].OnBuilt(event.created_entity)
	end	
end)

-- On entity removed
script.on_event(defines.events.on_robot_pre_mined, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if eventsControl[event.entity.type] and eventsControl[event.entity.type].OnRemoved then
		eventsControl[event.entity.type].OnRemoved(event.entity)
	elseif eventsControl["any"] and eventsControl["any"].OnRemoved then
		eventsControl["any"].OnRemoved(event.entity)
	end	
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if eventsControl[event.entity.type] and eventsControl[event.entity.type].OnRemoved then
		eventsControl[event.entity.type].OnRemoved(event.entity)
	elseif eventsControl["any"] and eventsControl["any"].OnRemoved then
		eventsControl["any"].OnRemoved(event.entity)
	end	
end)

-- On equipment placed
script.on_event(defines.events.on_player_placed_equipment, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if eventsControl[event.equipment.name] and eventsControl[event.equipment.name].OnEquipmentPlaced then
		eventsControl[event.equipment.name].OnEquipmentPlaced(event)
	end	
end)

-- On equipment removed
script.on_event(defines.events.on_player_removed_equipment, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end	
	if eventsControl[event.equipment.name] and eventsControl[event.equipment].OnEquipmentRemoved then
		eventsControl[event.equipment.name].OnEquipmentRemoved(event)
	end
end)

--On train created
script.on_event(defines.events.on_train_created, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if OnTrainCreated then OnTrainCreated(event) end
end)

--On train state changed
script.on_event(defines.events.on_train_changed_state, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if OnTrainStateChanged then OnTrainStateChanged(event) end
end)

---------------------------------------------------
-- GUI
---------------------------------------------------
-- On gui opened
script.on_event(defines.events.on_gui_opened, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	local entity=event.entity	
	if entity and GuiEntities[entity.type] and 
	(not GuiEntities[entity.type].CanOpenGui or GuiEntities[entity.type].CanOpenGui(entity)) then
		GuiEntities[entity.type]:addToGui(GuiEntities[entity.type].mainGui,GuiEntities[entity.type].data[getUnitId(entity)])		
	end
end)

-- On gui closed
script.on_event(defines.events.on_gui_closed, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	local entity=event.entity		
	if entity and GuiEntities[entity.type] and GuiEntities[entity.type].closeGui then		
		GuiEntities[entity.type]:closeGui()		
		MappingGuiObject={}
		InitGuiBuild()
	end
		
end)

-- On gui clicked
script.on_event(defines.events.on_gui_click, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_click) end
end)

-- On gui text changed
script.on_event(defines.events.on_gui_text_changed, function(event)
	if technologyName and not player.force.technologies[technologyName].researched then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_text_changed) end
	if UpdateData then UpdateData(event.element) end
end)

-- On gui checked state changed
script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_checked_state_changed) end
	if UpdateData then UpdateData(event.element) end
end)

--on gui value changed
script.on_event(defines.events.on_gui_value_changed, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_value_changed) end
	if UpdateData then UpdateData(event.element) end
end)

-- On gui selection state changed
script.on_event(defines.events.on_gui_selection_state_changed, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_selection_state_changed) end
	if UpdateData then UpdateData(event.element) end
end)

-- On gui element changed
script.on_event(defines.events.on_gui_elem_changed, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if OnAction then OnAction(event.element,defines.events.on_gui_elem_changed) end
	if UpdateData then UpdateData(event.element) end
end)

-- On copy paste
script.on_event(defines.events.on_pre_entity_settings_pasted, function(event)
	if (technologyName and not player.force.technologies[technologyName].researched)
		or not GuiEntities then			
		return		
	end
	if event.source.type==event.destination.type and GuiEntities[event.destination.type] then
		if event.destination.type=="locomotive" then
			GuiEntities[event.destination.type].table[event.destination.train.id]=clone(GuiEntities[event.destination.type].table[event.source.train.id])
		else
			GuiEntities[event.destination.type].table[event.destination.unit_number]=clone(GuiEntities[event.destination.type].table[event.source.unit_number])
		end
	end
end)

-- On research finished
script.on_event(defines.events.on_research_finished, function(event)
	if event.research.name==technologyName and OnResearchFinished then			
		OnResearchFinished()
	end
end)

-- On Custom key fired
function InitCustomEvents()
	for eventName,calledFunction in pairs(listCustomEvents) do
		script.on_event(eventName,function(event)
			if technologyName and not player.force.technologies[technologyName].researched then			
				return		
			end
			if calledFunction then calledFunction(event) end
		end)
	end
end