local currentRuleLabelGuiElement
local function initListRules()
	--Display
	local newRule=LuaGuiObject:new {type="flow",direction="horizontal",onRemove=CloseRuleFrame}
	newRule:add{type="label",name="ruleName", caption="new rule",onAction=DisplayRuleContent}
	GuiEntities[InputTAC]=LuaGuiObject:new{type="frame",name="TACFrame",direction="vertical",caption={"TAC"}}
	GuiEntities[InputTAC]:add{type="table",name="rules",direction="vertical",column_count=1,childGuiObject=newRule}
	GuiEntities[InputTAC]:add{type="button",name="close",caption={"Close"},onAction=CloseFrame}
	
	--Initialize
	GuiEntities[InputTAC].data=listTAC
	GuiEntities[InputTAC].mainGui="center"
	GuiEntities[InputTAC].CloseDefaultGui=true
end

local function initRuleDisplay()
	ruleGuiFrame=LuaGuiObject:new{type="frame",name="ruleGuiFrame",direction="vertical"}
	local ruleNameFlow=ruleGuiFrame:add{type="flow",name="ruleNameFlow",direction="horizontal"}
	ruleNameFlow:add{type="label",name="labelRuleName",caption={"Rule Name"},noSaveInData=true}
	ruleNameFlow:add{type="textfield",name="ruleName",onAction=UpdateRuleName,text="new rule",noSaveInData=true}
	
	--Conditions
	local listConditionTexts={}
	for _,protoCondition in pairs(listPrototypesConditions) do
		table.insert(listConditionTexts,protoCondition.text)
	end
	newCondition=LuaGuiObject:new{type="flow",direction="horizontal"}
	newCondition:add{type="drop-down",items=listConditionTexts,name="method",onAction=UpdateParameters}
	newCondition:add{type="flow",name="parameters",direction="horizontal",onLoad=LoadParameters}
	
	conditionsGuiFrame=ruleGuiFrame:add{type="frame",name="conditionsGuiFrame",direction="vertical",caption={"Conditions"}}
	conditionsGuiFrame:add{type="table",name="conditions",direction="vertical",column_count=1,childGuiObject=newCondition}
	
	--Actions
	local listActionsTexts={}
	for _,protoAction in pairs(listPrototypesActions) do
		table.insert(listActionsTexts,protoAction.text)
	end
	newAction=LuaGuiObject:new{type="flow",direction="horizontal"}
	newAction:add{type="drop-down",items=listActionsTexts,name="method",onAction=UpdateParameters}
	newAction:add{type="flow",name="parameters",direction="horizontal",onLoad=LoadParameters}
	
	actionFrame=ruleGuiFrame:add{type="frame",name="actionGuiFrame",direction="vertical",caption={"Actions"}}
	actionFrame:add{type="table",name="actions",direction="vertical",column_count=1,childGuiObject=newAction}
	
end

function InitGuiBuild()
	initListRules()
	initRuleDisplay()
end

function CloseFrame()
	GuiEntities[InputTAC]:closeGui()
end

function CloseRuleFrame(guiElement)
	local currentRuleFrame=game.players[1].gui.center.ruleGuiFrame
	if currentRuleFrame and (not guiElement or guiElement["ruleName"].index==currentRuleLabelGuiElement.index) then
		currentRuleFrame.destroy()
	end
end

function OnParameterAction(guiElement)
--Check if fullfilled
	local arrayData=getElementData(guiElement.parent.parent)
	local i=0
	for _,_ in pairs(getElementData(guiElement.parent)) do i=i+1 end
	arrayData.areAllParametersFilled=(#guiElement.parent.children==i)
	
--Reinit
	listTAC[global.LuaGuiElementsData.openedEntity.unit_number]:reinitTrainData()
end

function DisplayRuleContent(guiElement)
	currentRuleLabelGuiElement=guiElement
	local parentData=getElementData(guiElement.parent)
	CloseRuleFrame()
	local ruleContentElement=ruleGuiFrame:addToGui(game.players[1].gui.center,parentData)
	ruleContentElement.ruleNameFlow.ruleName.text=guiElement.caption
end

function LoadParameters(guiElement)
	local listPrototypes
	if guiElement.parent.parent.name=="actions" then
		listPrototypes=listPrototypesActions
	elseif guiElement.parent.parent.name=="conditions" then
		listPrototypes=listPrototypesConditions
	end
	local selectedData=guiElement.parent.method.items[guiElement.parent.method.selected_index] or {}
	selectedData=selectedData[1] or selectedData
	if not selectedData or not listPrototypes[selectedData] then
		return
	end
	--Build Gui with parameters
	guiElement.clear()
	for _,parameter in pairs(listPrototypes[selectedData].parameters) do
		local paramGuiObject=LuaGuiObject:new(parameter):addToGui(guiElement)
	end

end

function UpdateParameters(guiElement)
	local listPrototypes
	if guiElement.parent.parent.name=="actions" then
		listPrototypes=listPrototypesActions
	elseif guiElement.parent.parent.name=="conditions" then
		listPrototypes=listPrototypesConditions
	end
	local selectedData=guiElement.items[guiElement.selected_index] or {}
	selectedData=selectedData[1] or selectedData
	if not selectedData or not listPrototypes[selectedData] then
		return
	end
	
	--Build Gui with parameters
	guiElement.parent.parameters.clear()
	setElementData(guiElement.parent.parameters,{})
	for _,parameter in pairs(listPrototypes[selectedData].parameters) do
		local paramGuiObject=LuaGuiObject:new(parameter):addToGui(guiElement.parent.parameters)
	end
end

function UpdateRuleName(guiElement)
	currentRuleLabelGuiElement.caption=guiElement.text
	UpdateData(currentRuleLabelGuiElement)
end