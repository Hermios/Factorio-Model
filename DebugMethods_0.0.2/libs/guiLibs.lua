GuiEntities={}
MappingGuiObject={}
LuaGuiObject={}
CheckedData={}

function InitGuiLibs()
	LeftGui=player.gui.left
	CenterGui=player.gui.center
end

function OnClick(guiElement)
	--build guiElementPath
	local path=guiElement.name
	local currentGuiElement=guiElement
	while currentGuiElement.parent and currentGuiElement.parent.parent do
		currentGuiElement=currentGuiElement.parent
		path=currentGuiElement.name..">"..path
	end
	--call updateEntity
	if MappingGuiObject[path] and MappingGuiObject[path].luaGuiObject.onClick then
		MappingGuiObject[path].luaGuiObject.onClick(MappingGuiObject[path])
	end
end

function UpdateData(guiElement)
	--build guiElementPath
	local path=guiElement.name
	local currentGuiElement=guiElement
	while currentGuiElement.parent and currentGuiElement.parent.parent do
		currentGuiElement=currentGuiElement.parent
		path=currentGuiElement.name..">"..path
	end
	--call updateEntity
	if MappingGuiObject[path] then
	MappingGuiObject[path].luaGuiObject:updateData(MappingGuiObject[path].guiElement,MappingGuiObject[path].data)
	end
end

function LuaGuiObject:new(gui,path,newName)
	local guiName=newName or gui.name
	local o=
	{
		content=gui.content,
		path=(path or "")..guiName,
		onClick=gui.onClick,
		childGuiObject=gui.childGuiObject,
		children={}
	}
	gui.content=nil
	gui.onClick=nil
	gui.childGuiObject=nil
	o.gui=clone(gui)
	o.gui.name=guiName
	setmetatable(o, self)
    self.__index = self
	return o
end

function LuaGuiObject:clone(startPath,newName)
	local guiName=newName or self.gui.name
	local o=
	{
		content=self.gui.content,
		gui=clone(self.gui),
		path=(startPath or "")..guiName,
		onClick=self.gui.onClick,
		childGuiObject=self.gui.childGuiObject,
		children={}
	}
	for index,child in pairs (self.children) do
		o.children[index]=child:clone(o.path..">")
	end
	o.gui.name=guiName
	setmetatable(o, self)
    self.__index = self
	return o
end
	
function LuaGuiObject:updateGuiElement(data)
	if 	self.gui.type=="checkbox" or self.gui.type=="radiobutton"then
		self.gui.state=data[self.content]
	elseif self.gui.type=="progressbar" or self.gui.type=="slider" then
		self.gui.value=data[self.content]
	elseif self.gui.type=="textfield" or self.gui.type=="text-box" then
		self.gui.text=data[self.content]
	elseif self.gui.type=="choose-elem-button" then	
		self.gui[self.gui.elem_type]=data[self.content]
	elseif self.gui.type=="drop-down" then
		local i=0
		while (i<#(self.gui.items) and self.gui.selected_index==0) do if self.gui.items[i]==data[self.content] then self.gui.selected_index=i end i=i+1 end		
	elseif self.gui.type=="table" and self.childGuiObject then
		for i,_ in pairs(data[self.content]) do 
			self:add(self.childGuiObject,self.childGuiObject.gui.name.."_"..i,i)
		end	
	end	
end

function LuaGuiObject:updateData(guiElement,data)
	if 	guiElement.type=="checkbox" or guiElement.type=="radiobutton"then
		data[self.content]=guiElement.state
	elseif guiElement.type=="progressbar" or guiElement.type=="slider" then
		data[self.content]=guiElement.value
	elseif guiElement.type=="textfield" or guiElement.type=="text-box" then
		data[self.content]=guiElement.text
	elseif guiElement.type=="choose-elem-button" then	
		data[self.content]=guiElement.elem_value
	elseif guiElement.type=="drop-down" then
		data[self.content]=guiElement.items[guiElement.selected_index]
	end
end
	
function LuaGuiObject:add(object,newName,index)
	if not object.gui then 
		object=LuaGuiObject:new(object,self.path..">",newName) 
	else
		object=object:clone(self.path..">",newName) 
	end
	object.content=index or object.content
	self.children[object.gui.name]=object
	object.parent=self
	return object
end

function LuaGuiObject:addToGui(parent,data,rootData)
	local rootData=rootData or data
	local parent=parent or LeftGui
	if self.content and data[self.content]~=nil then
		self:updateGuiElement(data)
	end
	local guiElement=parent.add(self.gui)
	MappingGuiObject[self.path]={luaGuiObject=self,guiElement=guiElement,data=data,rootData=rootData}
	for _,child in pairs(self.children) do
		child:addToGui(guiElement,data[self.content] or data,rootData)
	end
end

function checkData(gui)
	if not CheckedData[gui.index] then
		return
	end
	if gui.type=="textfield" or gui.type=="text-box" then
		if CheckedData[gui.index].check=="int" and gui.text~="" and not tonumber(gui.text) then
				gui.text=CheckedData[gui.index].oldValue or ""
			else
				CheckedData[gui.index].oldValue=gui.text
		end
	end
end

function LuaGuiObject:closeGui(luaGuiElement)	
	if not luaGuiElement then
		self.mainGui.clear()
		return
	end
	--find main window
	while luaGuiElement.gui~=luaGuiElement.parent do
			luaGuiElement=luaGuiElement.parent
	end
	--close main window
	luaGuiElement.destroy()
end
