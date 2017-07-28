GuiEntities={}
guiElementEntities={}

function openGui()
	local currentGuiEntity=player.opened		
	if not currentGuiEntity or not GuiEntities[currentGuiEntity.type] then	
		CloseAllGuis()
	elseif not getFrame(LeftGui,currentGuiEntity) and entities[currentGuiEntity.type] and entities[currentGuiEntity.type].CanOpenGui and entities[currentGuiEntity.type].CanOpenGui(currentGuiEntity)
	then	
		--set up new frame
		addToFrame(LeftGui,{GuiEntities[currentGuiEntity.type]})
		--Update gui values
		if entities[currentGuiEntity.type].UpdateGui then
			entities[currentGuiEntity.type].UpdateGui(currentGuiEntity)
		end
	end
end

function OnUpdateFromGui()
	local entity=player.opened
	if entities[entity.type] and entities[entity.type].UpdateFromGui then
		entities[entity.type].UpdateFromGui(entity)
	end	
end

function InitGuiLibs()
LeftGui=player.gui.left
CenterGui=player.gui.left
end

function getFrame(gui,children,index)
	if not ModName then
		err("ModName value not defined")
	end
	if not gui then
		return nil
	end
	if not index then index=1 end
	local frame=gui
	if children and type(children)~="table"  or children.type then
		children={children}
	end
	if not children or index>#children then
		return gui
	end
	local element=children[index]
	if type(element)=="table" and element.type then
		if GuiEntities[element.type] then
			element=GuiEntities[element.type].name
		else
			element=element.name
		end
	end
	return getFrame(gui[ModName.."."..element],children,index+1)
end

function getElementNameFromEvent(event)
local mod,name=string.match(event.element.name,"(%a-)%.(.+)")
	if not mod or mod~=ModName then
		return nil
	end			
	return name
end

function addToFrame(parentFrame,childrenFrames)
	if type(childrenFrames)=="string" or childrenFrames.type then
		childrenFrames={childrenFrames}
	end
	for _,childFrame in pairs(childrenFrames) do
		local child={}
		local signalsData
		for key,value in pairs(childFrame) do
			if key~="children" then
				if key=="name" then
					value=ModName.."."..value
				end
				child[key]=value
			end
		end
		if not parentFrame[child.name] then
			luaGuiElement=parentFrame.add(child)
			if guiElementEntities[childFrame.name] and guiElementEntities[childFrame.name].OnAddToFrame then
				guiElementEntities[childFrame.name].OnAddToFrame(luaGuiElement)
			end
		end
		if childFrame.children and #childFrame.children>0 then
			addToFrame(parentFrame[child.name],childFrame.children)
		end
	end
end

function CloseAllGuis()
	for currentGui,_ in pairs(GuiEntities) do
		for _,gui in pairs(player.gui.children) do
			if getFrame(gui,GuiEntities[currentGui]) then
				getFrame(gui,GuiEntities[currentGui]).destroy()
			end
		end
	end
end