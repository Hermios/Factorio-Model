conditionGui={}
stationNameGui={}
guiElementEntities["StationsListFrame"]={}
guiElementEntities["trainCallerFrame"]={}
local function initLocomotiveGui()
	GuiEntities["locomotive"]={
		type="frame",name="trainCallerFrame",direction="vertical",caption={"default-train-station"},children=
		{
			{type="drop-down",name="stationsDropDown",caption={"select-a-default-station"}}
		}
	}
end

local function initTrainStopGui()
	GuiEntities["train-stop"]={
		type="frame",name="trainStopCaller",direction="vertical",caption={"train-caller-mod"},children=
		{
			{type="checkbox",name="activateNetworkCheckbox",caption={"activate-network-call-train"},state=false},
			{type="checkbox",name="activateCircuitCheckbox",caption={"activate-circuit-call-train"},state=false},
			{type="flow",name="trainStopConditions",direction="vertical"},
			{type="button",name="AddCondition",caption="+",style="logistic_button_slot_style"}
		}
	}
end

function InitGuiBuild()
	initLocomotiveGui()
	initTrainStopGui()
end

function conditionGui.new(index)
	return {
		type="flow",name="conditionFlow."..index,direction="horizontal",children=
		{
			{type="label",name="ifLabel",caption={"if"}},
			SignalButton.new("signal1."..index),
			{type="drop-down",name="signal.comparator",items={"=",">","<"},selected_index=1},
			SignalButton.new("signal2."..index,nil,true),
			{type="label",name="resultConditionLabel",caption={"call-for-the-element"}},
			SignalButton.new("signal3."..index),
			{type="button",name="RemoveCondition",caption="-",style="ability_slot_style"}
		}
	}
end