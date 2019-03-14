local function initPumpGui()
	GuiEntities["pump"]=LuaGuiObject:new{type="frame",name="pumpFrame",direction="vertical",caption={"PumpFilter"}}
	GuiEntities["pump"]:add{type="choose-elem-button",name="fluid",elem_type="fluid",onAction=UpdateFilter}
	GuiEntities["pump"].data=listPumps
	GuiEntities["pump"].mainGui="left"
	GuiEntities["pump"].allowType=true
end

function InitGuiBuild()
	initPumpGui()
end

function UpdateFilter(guiElement)
	if guiElement.elem_value then
		local successFilter=game.players[1].opened.fluidbox.set_filter(1,{name=guiElement.elem_value,force=true})
	end
end