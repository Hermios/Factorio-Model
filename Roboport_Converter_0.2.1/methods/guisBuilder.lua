local function initRoboportGui()
	GuiEntities["roboport"]=LuaGuiObject:new{type="frame",name="pumpFrame",direction="vertical",caption={"RoboportConverter"}}
	GuiEntities["roboport"]:add{type="checkbox",name="activate",state=false,caption={"activate"}}
	GuiEntities["roboport"].data=listRoboport
	GuiEntities["roboport"].mainGui="left"
	GuiEntities["roboport"].allowType=true
end

function InitGuiBuild()
	initRoboportGui()
end