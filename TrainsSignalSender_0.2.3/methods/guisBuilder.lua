local function initLocomotiveGui()
	newSignal=LuaGuiObject:new{name="newSignalFlow",type="flow",direction="horizontal"}	
	newSignal:add{type="choose-elem-button",name="signal",elem_type="signal",content="signal",signal={type="item"}}
	newSignal:add{type="slider",name="sliderSignalCount",content="count",onAction=ChangeValue,minimum_value=1,maximum_value=5000}
	newSignal:add{type="textfield",name="textSignalCount",content="count",onAction=ChangeValue}
	newSignal:add{type="button",name="RemoveSignal",caption="-",style="logistic_button_slot",onAction=RemoveSignal}
	GuiEntities["locomotive"]=LuaGuiObject:new{type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"}}
	GuiEntities["locomotive"]:add{type="table",name="signalsTable",direction="vertical",column_count=1,content="signals",childGuiObject=newSignal}
	GuiEntities["locomotive"]:add{type="button",name="addSignal",caption="+",style="logistic_button_slot",onAction=AddSignal}
	GuiEntities["locomotive"].CanOpenGui=function()
		return player.force.technologies[technologyName].researched		
	end
	GuiEntities["locomotive"].data=listTrains
	GuiEntities["locomotive"].mainGui=LeftGui
end

local function initTrainStationGui()
	GuiEntities["train-stop"]=LuaGuiObject:new{type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"}}
	GuiEntities["train-stop"]:add{type="checkbox",name="setDifferenceCheck",content="setDifference",caption={"trainstop-set-difference"},state=false}
	GuiEntities["train-stop"].data=listTrainsStop
	GuiEntities["train-stop"].mainGui=LeftGui
end

function InitGuiBuild()			
	initLocomotiveGui()
	initTrainStationGui()
end

function AddSignal(content)
	table.insert(content.rootData.signals,{signal={type="item"},count=1})
	local localNewSignal=content.luaGuiObject.parent.children["signalsTable"]:add(newSignal,newSignal.gui.name.."_"..tostring(#content.rootData.signals),#content.rootData.signals)	
	localNewSignal:addToGui(content.guiElement.parent.signalsTable,content.rootData.signals,content.rootData)
end

function ChangeValue(content)
	if content.guiElement.type=="slider" then
		content.guiElement.slider_value=math.floor(content.guiElement.slider_value)
		content.guiElement.parent.textSignalCount.text=content.guiElement.slider_value
	else
		if tonumber(content.guiElement.text) then
			content.guiElement.parent.sliderSignalCount.slider_value=tonumber(content.guiElement.text)
		else
			content.guiElement.text=content.guiElement.parent.sliderSignalCount.slider_value
		end
	end
end
function RemoveSignal(content)
	local index=1
	while content.guiElement.parent.parent.children_names[index]~=content.guiElement.parent.name do
		index=index+1
	end
	table.remove(content.rootData.signals,index)
	content.guiElement.parent.destroy()
end