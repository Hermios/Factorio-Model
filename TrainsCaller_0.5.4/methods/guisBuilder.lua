local function initLocomotiveGui()
	GuiEntities["locomotive"]=LuaGuiObject:new{type="frame",name="trainCallerFrame",direction="vertical",caption={"TrainCaller"}}
	local allowMultipleCalls=GuiEntities["locomotive"]:add{type="flow",name="AllowMultipleCallsFlow",direction="horizontal"}
	allowMultipleCalls:add{type="checkbox",name="allowMultipleCalls",caption={"allowMultipleCalls"}, state=true}
	GuiEntities["locomotive"].CanOpenGui=function()
		return listTrains[game.players[1].opened.train.id]~=nil
	end
	GuiEntities["locomotive"].data=listTrains
	GuiEntities["locomotive"].mainGui="left"
	GuiEntities["locomotive"].allowType=true
end

function InitGuiBuild()
	initLocomotiveGui()
end