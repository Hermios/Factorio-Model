local itemSelectionFrame="itemSelectionFrame"
local groups={}

local ItemButton={}
local GroupButton={}
SignalButton={}

local defaultGroupsNames={}
local groupsNames={}

guiElementEntities["closeButton"]={}
guiElementEntities["OKButton"]={}

currentSelectedSignal=nil
local currentSelectedGroup=nil

local function initGroups(itemsArray,imageSubDir,groupName)
	for _,item in pairs(itemsArray) do
		if item.valid and (item~="item" or not item.has_flag("hidden")) then
			local name=groupName or item.group.name
			if not guiElementEntities[name] then
				table.insert(defaultGroupsNames,name)
				groups[name]=GroupButton.new(name,imageSubDir)								
			end	
			--add item
			guiElementEntities[name].add(item)
		end
	end
end

function selectGroup(index)
	guiElementEntities[groupsNames[index]].OnGuiClicked(nil,guiElementEntities[groupsNames[index]].luaGuiElement)
end

function ItemButton.new(item,imageSubDir)
	local itemButton={type="sprite-button",sprite=imageSubDir.."/"..item.name,name=item.name,style="logistic_button_slot_style",tooltip=item.name}
	guiElementEntities[item.name]={}
	guiElementEntities[item.name].OnGuiClicked=function(entity,element)
		currentSelectedSignal.Set(element.sprite)
		OnUpdateFromGui()
		getFrame(LeftGui,itemSelectionFrame).destroy()
	end
	guiElementEntities[item.name].OnAddToFrame=function(luaGuiElement)
		guiElementEntities[item.name].luaGuiElement=luaGuiElement
	end
	return itemButton
end

function GroupButton.new(name,imageSubDir)
	local groupButton={type="sprite-button",sprite="item-group/"..name,name=name,style="image_tab_slot_style",tooltip=name}
	guiElementEntities[name]={}
	guiElementEntities[name].children={} 
	guiElementEntities[name].OnGuiClicked=function(entity,element)
		--style of the group
		if currentSelectedGroup and currentSelectedGroup.valid then
			currentSelectedGroup.style="image_tab_slot_style"
		end
		currentSelectedGroup=guiElementEntities[name].luaGuiElement
		currentSelectedGroup.style="image_tab_selected_slot_style"
		--Display new elements
		local elementsFrame=getFrame(LeftGui,{itemSelectionFrame,"elementsFrame"})
		elementsFrame.clear()
		addToFrame(elementsFrame,guiElementEntities[name].children)
	end
	guiElementEntities[name].OnAddToFrame=function(luaGuiElement)
		guiElementEntities[name].luaGuiElement=luaGuiElement
	end
	guiElementEntities[name].add=function(item)
		if item.subgroup then
			if not guiElementEntities[name].children[item.subgroup.name] then
				guiElementEntities[name].children[item.subgroup.name]={type="flow",name=item.subgroup.name,direction="horizontal",style="search_flow_style",children={}}
			end
			table.insert(guiElementEntities[name].children[item.subgroup.name].children,ItemButton.new(item,imageSubDir))
		else
			table.insert(guiElementEntities[name].children,ItemButton.new(item,imageSubDir))
		end
	end
	return groupButton
end

local spriteToSignal=function(sprite)
	if not sprite then
		return nil
	end
	if type(sprite)=="table" then
		return sprite
	end
	local result={type=string.match(sprite,"(%a+)"),name=string.match(sprite,"%.-%/(.+)")}
	if not result.type or not result.name then
		return nil
	end
	return result
end

local signalToSprite=function(signal)
	if not signal then
		return ""
	end
	if type(signal)~="table" then
		return signal
	end
	if not signal.type or not signal.name then
		return ""
	end
	local signalType=signal.type
	if signalType=="virtual" then
		signalType=signalType.."-signal"
	end
	return signalType.."/"..signal.name
end

local function setSignalStyle(isSelected)
	local style="logistic_button_slot_style"
	if isSelected then
		style="logistic_button_selected_slot_style"
	end
	if currentSelectedSignal and currentSelectedSignal.luaGuiElement and currentSelectedSignal.valid then
		if currentSelectedSignal.luaGuiElement[currentSelectedSignal.luaGuiElement.name] and currentSelectedSignal.luaGuiElement[currentSelectedSignal.luaGuiElement.name].valid then
				currentSelectedSignal.luaGuiElement[currentSelectedSignal.luaGuiElement.name].style=style
		end
	end
end

function SignalButton.new(name,signalGroups,quantity,canSelect)
	local signalButton= {
		name=name,type="flow",direction="horizontal",children=
		{
			{
				name=name,type="sprite-button",sprite="",style="logistic_button_slot_style"
			}
		}
	}
	guiElementEntities[name]={name=name}
	guiElementEntities[name].OnAddToFrame=function(luaGuiElement)
		if luaGuiElement.type=="flow" then
			guiElementEntities[name].luaGuiElement=luaGuiElement
		end
	end
	
	guiElementEntities[name].OnGuiClicked=function()
		setSignalStyle(false)
		if not canSelect or not guiElementEntities[name].value or currentSelectedSignal==guiElementEntities[name] then
			addToFrame(LeftGui,GuiEntities[itemSelectionFrame])
			groupsNames={}
			if signalGroups and #signalGroups>0 then
				for _,groupName in pairs(signalGroups) do
					table.insert(groupsNames,groupName)
					addToFrame(getFrame(LeftGui,{itemSelectionFrame,"groupFrame"}),signalGroups[groupName])
				end
			else
				groupsNames=defaultGroupsNames
				addToFrame(getFrame(LeftGui,{itemSelectionFrame,"groupFrame"}),groups)
			end
			if not quantity then
				getFrame(LeftGui,{itemSelectionFrame,"quantityFrame"}).destroy()
			end
			selectGroup(1)
		end
		currentSelectedSignal=guiElementEntities[name]
		setSignalStyle(true)
		if OnSignalSelected then
			OnSignalSelected(name)
		end
	end	
	
	guiElementEntities[name].Set=function(data)
		local signal=spriteToSignal(data)
		if guiElementEntities[name].luaGuiElement and guiElementEntities[name].luaGuiElement.valid then
			guiElementEntities[name].luaGuiElement.clear()
			if signal then
				guiElementEntities[name].value=signal
				addToFrame(guiElementEntities[name].luaGuiElement,{{type="sprite-button",name=name,sprite=signalToSprite(data),style="logistic_button_slot_style"}})
			else
				guiElementEntities[name].value=tonumber(data) or data or ""
				addToFrame(guiElementEntities[name].luaGuiElement,{{type="button",name=name,caption=guiElementEntities[name].value,style="logistic_button_slot_style"}})
			end
		end
		setSignalStyle(true)
	end
	return signalButton
end

function getCurrentSelectedSignalName()
	return currentSelectedSignal.name
end

guiElementEntities["closeButton"].OnGuiClicked=function(element,entity)
	currentSelectedSignal.Set("")
	currentSelectedSignal=nil
	OnUpdateFromGui()
	getFrame(LeftGui,itemSelectionFrame).destroy()
end

guiElementEntities["OKButton"].OnGuiClicked=function(element,entity)
	if not currentSelectedSignal then
		return
	end
	local intQuantity=tonumber(getFrame(LeftGui,{itemSelectionFrame,"quantityFrame","quantity.textfield"}).text)
	if not intQuantity then
		return
	end
	currentSelectedSignal.Set(intQuantity)
	currentSelectedSignal=nil
	OnUpdateFromGui()
	getFrame(LeftGui,itemSelectionFrame).destroy()
end

function InitSignalLib()
	initGroups(game.item_prototypes,"item",nil)
	initGroups(game.fluid_prototypes,"fluid",nil)
	initGroups(game.virtual_signal_prototypes,"virtual-signal","signals")
	
	GuiEntities[itemSelectionFrame]=
	{
		type="frame",name="itemSelectionFrame",direction="vertical",caption={"gui-signal-title"},children=
		{
			{type="flow",name="groupFrame",children={}},
			{type="flow",name="elementsFrame",direction="vertical",children={}},
			{
				type="flow",name="quantityFrame",direction="horizontal",children=
				{
					{type="textfield",name="quantity.textfield",style="number_textfield_style"},
					{type="button",name="OKButton",caption="OK"}
				},
			},
			{type="button",name="closeButton",caption={"close-button"}}
		}
	}
end
