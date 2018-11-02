local function initLocomotiveGui()
	GuiEntities["locomotive"]=LuaGuiObject:new{type="frame",name="trainCallerFrame",direction="vertical",caption={"TrainCaller"}}
	local allowMultipleCalls=GuiEntities["locomotive"]:add{type="flow",name="AllowMultipleCallsFlow",direction="horizontal"}
	allowMultipleCalls:add{type="checkbox",name="allowMultipleCallsCheckbox",caption={"allowMultipleCalls"},content="allowMultipleCalls"}
	GuiEntities["locomotive"].CanOpenGui=function()
		return listTrains[player.opened.train.id]~=nil
	end
	GuiEntities["locomotive"].data=listTrains
	GuiEntities["locomotive"].mainGui=LeftGui
end

function InitGuiBuild()
	initLocomotiveGui()
end