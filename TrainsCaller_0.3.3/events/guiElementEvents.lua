--declaration arrays
guiElementEntities["stationsDropDown"]={}
guiElementEntities["AddCondition"]={}
guiElementEntities["RemoveCondition"]={}

guiElementEntities["stationsDropDown"].OnGuiSelectionStateChanged=function(entity,element)
	OnUpdateFromGui()
end

guiElementEntities["AddCondition"].OnGuiClicked=function(entity,element)
	local i=0
	while(getFrame(LeftGui,{entity,"trainStopConditions","conditionFlow."..i})) do
		i=i+1
	end
	addToFrame(getFrame(LeftGui,{entity,"trainStopConditions"}),{conditionGui.new(i)})
end

guiElementEntities["RemoveCondition"].OnGuiClicked=function(entity,element)
	element.parent.destroy()
	OnUpdateFromGui()
end