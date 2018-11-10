PumpPrototype={}

function PumpPrototype:new (entity,sourceData)
	if entity.valid==false then
		return nil
	end
	local o=sourceData or 
	{
		entity=entity,
		filteringFluidName="",
		
	}
	setmetatable(o, self)
    self.__index = self
	return o
end

--[[function PumpPrototype:updateStatus(train,sourceData)
	if self.entity and self.entity.valid and self.previousPipe and self.previousPipe.valid and self.previousPipe.fluidbox and #self.previousPipe.fluidbox==1 and self.previousPipe.fluidbox[1] then
		self.entity.active=(self.previousPipe.fluidbox[1].name==self.filteringFluidName)
	end
end]]--

--[[function PumpPrototype:setPreviousPipe()
	local neighbours=self.entity.neighbours[1]
	if #neighbours==0 then
		return
	end
	if self.entity.direction==0 then
		if neighbours[1].position.y>self.entity.position.y then
			self.previousPipe=neighbours[1]
		else
			self.previousPipe=neighbours[2]
		end
	elseif self.entity.direction==2 then
		if neighbours[1].position.x<self.entity.position.x then
			self.previousPipe=neighbours[1]
		else
			self.previousPipe=neighbours[2]
		end
	elseif self.entity.direction==4 then
		if neighbours[1].position.y<self.entity.position.y then
			self.previousPipe=neighbours[1]
		else
			self.previousPipe=neighbours[2]
		end	
	elseif self.entity.direction==6 then
		if neighbours[1].position.x>self.entity.position.x then
			self.previousPipe=neighbours[1]
		else
			self.previousPipe=neighbours[2]
		end
	end
end]]--