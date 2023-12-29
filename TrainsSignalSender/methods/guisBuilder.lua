local function ChangeValue(guiElement)
	if guiElement.type=="slider" then
		guiElement.slider_value=math.floor(guiElement.slider_value)
		guiElement.parent.textSignalCount.text=guiElement.slider_value		
	else
		if tonumber(guiElement.text) then
			guiElement.parent.count.slider_value=tonumber(guiElement.text)
			UpdateData(guiElement.parent.count)
		else
			guiElement.text=guiElement.parent.count.slider_value
		end
	end
	guiElement.parent.signal.number=guiElement.parent.count.slider_value
end

local function updateCount(guiElement)
		guiElement.parent.count.slider_value=math.floor(guiElement.parent.count.slider_value)
		guiElement.text=guiElement.parent.count.slider_value
		guiElement.parent.signal.number=guiElement.parent.count.slider_value
end

local function initLocomotiveGui()
	newSignal=LuaGuiObject:new{type="flow",direction="horizontal"}	
	newSignal:add{type="choose-elem-button",name="signal",elem_type="signal",signal={type="item"}}
	newSignal:add{type="slider",name="count",onAction=ChangeValue,minimum_value=1,discrete_slider=true,maximum_value=5000,value=1}
	newSignal:add{type="textfield",name="textSignalCount",onAction=ChangeValue,numeric=true,onLoad=updateCount, noSaveInData=true}
	GuiEntities["locomotive"]=LuaGuiObject:new{type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"}}
	GuiEntities["locomotive"]:add{type="table",name="signals",direction="vertical",column_count=1,childGuiObject=newSignal}
	GuiEntities["locomotive"].data=listTrains
	GuiEntities["locomotive"].mainGui="left"
	GuiEntities["locomotive"].allowType=true
end

local function initTrainStationGui()
	GuiEntities["train-stop"]=LuaGuiObject:new{type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"}}
	GuiEntities["train-stop"]:add{type="checkbox",name="setDifference",caption={"trainstop-set-difference"},state=false}
	GuiEntities["train-stop"].data=listTrainsStop
	GuiEntities["train-stop"].mainGui="left"
end

function InitGuiBuild()				
	initLocomotiveGui()
	initTrainStationGui()
end