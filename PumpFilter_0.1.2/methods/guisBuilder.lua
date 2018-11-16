local function initLocomotiveGui()
	GuiEntities["pump"]=LuaGuiObject:new{type="frame",name="pumpFrame",direction="vertical",caption={"PumpFilter"}}
	GuiEntities["pump"]:add{type="choose-elem-button",name="filteringFluidName",elem_type="fluid",content="fluid",onAction=UpdateFilter}
	GuiEntities["pump"].data=listPumps
	GuiEntities["pump"].mainGui=LeftGui
end

function InitGuiBuild()
	initLocomotiveGui()
end

function UpdateFilter(content)
player.print(content.guiElement.elem_value)
	if content.guiElement.elem_value then
		local successFilter=player.opened.fluidbox.set_filter(1,{name=content.guiElement.elem_value,force=true})
		player.print(successFilter)
	end
end