local function initLocomotiveGui()
	newSignal=LuaGuiObject:new{name="newSignalFlow",type="flow",direction="horizontal"}	
	newSignal:add{type="choose-elem-button",name="signal",elem_type="signal",content="signal",signal={},default_type="item"}
	newSignal:add{type="button",name="RemoveSignal",caption="-",style="logistic_button_slot",onClick=RemoveSignal}
	GuiEntities["locomotive"]=LuaGuiObject:new{type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"}}
	GuiEntities["locomotive"]:add{type="table",name="signalsTable",direction="vertical",column_count=1,content="signals",childGuiObject=newSignal}
	GuiEntities["locomotive"]:add{type="button",name="addSignal",caption="+",style="logistic_button_slot",onClick=AddSignal}
	GuiEntities["locomotive"].CanOpenGui=function()
		return player.force.technologies[technologyName].researched		
	end
	GuiEntities["locomotive"].data=listTrains
	GuiEntities["locomotive"].mainGui=LeftGui
end

function InitGuiBuild()			
	initLocomotiveGui()
end

function AddSignal(content)
	table.insert(content.rootData.signals,{signal={}})
	local localNewSignal=content.luaGuiObject.parent.children["signalsTable"]:add(newSignal,newSignal.gui.name.."_"..tostring(#content.rootData.signals),#content.rootData.signals)
	localNewSignal:addToGui(content.guiElement.parent.signalsTable,content.rootData.signals,content.rootData)
end

function RemoveSignal(content)
	local index=1
	while content.guiElement.parent.parent.children_names[index]~=content.guiElement.parent.name do
		index=index+1
	end
	table.remove(content.rootData.signals,index)
	content.guiElement.parent.destroy()
end