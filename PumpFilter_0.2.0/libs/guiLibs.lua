GuiEntities={}
LuaGuiObject={}
local AddButton
local RemoveButton

local function get_or_set_guiElementData(guiElement)
	global.LuaGuiElementsData[guiElement.index]=global.LuaGuiElementsData[guiElement.index] or {}
	return global.LuaGuiElementsData[guiElement.index]
end

function getGuiEntity(entity)
	if GuiEntities[entity.name] then
		return GuiEntities[entity.name]
	end
	if (GuiEntities[entity.type] or {}).allowType then
		return GuiEntities[entity.type]
	end
end

function getElementData(guiElement)
	return (get_or_set_guiElementData(guiElement).parentData or {})[guiElement.name]
end

function setElementData(guiElement,data)
	get_or_set_guiElementData(guiElement).parentData[guiElement.name]=data
end

function InitGuiLibs(init)
	if init then
		global.LuaGuiElementsData=global.LuaGuiElementsData or {}
	end
	RemoveButton=LuaGuiObject:new {type="button",name="removeButton",caption="X",style="logistic_button_slot",onAction=OnRemove}
	AddButton=LuaGuiObject:new {type="button",name="addButton",caption="+",style="logistic_button_slot",onAction=OnAdd}
end

function LuaGuiObject:new(object)
	o=
	{
		onAction=object.onAction,
		onLoad=object.onLoad,
		childGuiObject=object.childGuiObject,
		noSaveInData=object.noSaveInData,
		children=object.children,
		regexp=object.regexp,
		gui={}
	}
	for key,value in pairs(object) do
		if not o[key] then
			o.gui[key]=value
		end
	end
	setmetatable(o, self)
    self.__index = self
	return o
end

function updateGuiElement(guiElement)
	local data=getElementData(guiElement)
	if not data then
		return
	end
	if 	guiElement.type=="checkbox" or guiElement.type=="radiobutton"then
		guiElement.state=data
	elseif 	guiElement.type=="label" then
		guiElement.caption=data
	elseif guiElement.type=="progressbar" then
		guiElement.value=data
	elseif guiElement.type=="slider" then
		guiElement.slider_value=data	
	elseif guiElement.type=="textfield" or guiElement.type=="text-box" then
		guiElement.text=data
	elseif guiElement.type=="choose-elem-button" then
		guiElement.elem_value=data		
	elseif guiElement.type=="drop-down" then
		local i=1
		while i<=#(guiElement.items) and (guiElement.items[i][1] or guiElement.items[i])~=data do 
			i=i+1 
		end	
		if i<=#(guiElement.items) then
			guiElement.selected_index=i
		end
	end
end

function UpdateData(guiElement)
	local guiElementData=get_or_set_guiElementData(guiElement)
	if not guiElementData.luaGuiObject or guiElementData.luaGuiObject.noSaveInData==true then
		return
	end
	local data
	if 	guiElement.type=="checkbox" or guiElement.type=="radiobutton"then
		data=guiElement.state
	elseif guiElement.type=="progressbar" then
		data=guiElement.value
	elseif guiElement.type=="label" then
		data=guiElement.caption
	elseif guiElement.type=="slider" then
		data=guiElement.slider_value
	elseif guiElement.type=="textfield" or guiElement.type=="text-box" then
		data=guiElement.text
	elseif guiElement.type=="choose-elem-button" then	
		data=guiElement.elem_value
	elseif guiElement.type=="drop-down" then
		data=(guiElement.items[guiElement.selected_index] or {})[1] or guiElement.items[guiElement.selected_index]
	--If this is a container of dynamic children, or its parent is, the current item is initialize as a flow
	elseif guiElementData.luaGuiObject.childGuiObject then
		data=getElementData(guiElement) or {}
	elseif tonumber(guiElement.name) and (get_or_set_guiElementData(guiElement.parent).luaGuiObject or {}).childGuiObject then
		data=(getElementData(guiElement.parent)[tonumber(guiElement.name)] or {})
	end
	if not guiElementData.luaGuiObject.regexp or string.match(data,"^"..guiElementData.luaGuiObject.regexp.."$") then
		setElementData(guiElement,data)	
	else
		updateGuiElement(guiElement)
	end
end
	
function InitOpeningGui(data)
	global.LuaGuiElementsData={}
	global.LuaGuiElementsData.root=data
end

function LuaGuiObject:add(object)
	--create instance of the object to add
	if not object.gui then 
		object=LuaGuiObject:new(object) 
	else
		object=object:new(object) 
	end
	
	--Init children nif needed
	self.children=self.children or {}
	--Add the object in to parent object
	self.children[object.gui.name]=object
	object.parent=self
	return object
end

function LuaGuiObject:addToGui(parentGuiElement,parentData,name)
	local localGui=clone(self.gui)
	localGui.name=name or localGui.name
	--if child already exists, update its name to avoid conflicts
	if not localGui.name or parentGuiElement[localGui.name] then
		local i=1
		while parentGuiElement[tostring(i)] do
			i=i+1
		end
		localGui.name=tostring(i)
	end
	
	--Add to gui
	local guiElement=parentGuiElement.add(localGui)	
	local guiElementData=get_or_set_guiElementData(guiElement)
	guiElementData.luaGuiObject=self
	
	--Connect guiElement to its parent
	guiElementData.parentData=parentData or getElementData(parentGuiElement) or get_or_set_guiElementData(parentGuiElement).parentData or global.LuaGuiElementsData.root
	--update gui with data value
	updateGuiElement(guiElement)
	--init data
	if not getElementData(guiElement) then
		UpdateData(guiElement)
	end
	--action onload
	if self.onLoad then
		self.onLoad(guiElement)
	end
	
	--add predefined children	
	if self.children then
		for _,child in pairs(self.children) do
			child:addToGui(guiElement)
		end
	end
		
	--add custom children
	if self.childGuiObject then
		AddButton:addToGui(guiElement)
		--if has children, initialize the parent if this is a table
		setElementData(guiElement,getElementData(guiElement) or {})	
		for index,_ in pairs(getElementData(guiElement)) do
			if tonumber(index)~=nil then
				local tableGuiElement=self.childGuiObject:addToGui(guiElement,nil,index)
				RemoveButton:addToGui(tableGuiElement)
			end
		end
	end
	return guiElement
end

function LuaGuiObject:closeGui(luaGuiElement)	
	if not luaGuiElement then
		game.players[1].gui[self.mainGui].clear()
		return
	end
	--find main window
	luaGuiElement.gui.clear()
end

function OnAction(guiElement,eventType)
	local guiElementData=get_or_set_guiElementData(guiElement)
	if (guiElementData.luaGuiObject or {}).onAction then
		guiElementData.luaGuiObject.onAction(guiElement)
	end
end

function OnAdd(guiElement)
	local guiElementParent=guiElement.parent
	--add child component
	local flowGuiElement=get_or_set_guiElementData(guiElementParent).luaGuiObject.childGuiObject:addToGui(guiElementParent)
	--add remove button
	RemoveButton:addToGui(flowGuiElement)
end

function OnRemove(guiElement)
	setElementData(guiElement.parent,nil)
	guiElement.parent.destroy()
end