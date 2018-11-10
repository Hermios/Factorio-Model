pumpEntity={}
eventsControl["pump"]=pumpEntity

--local functions
local function setPreviousPipe(entity)
	for _,neighbour in pairs(entity.neighbours) do
		local pump=listPumps[neighbour.unit_number]
		if pump and not pump.previousPipe then
			pump:setPreviousPipe()
		end
	end
end

local function removePreviousPipe(entity)
	for _,neighbour in pairs(entity.neighbours) do
		local pump=listPumps[neighbour.unit_number]
		if pump and pump.previousPipe.unit_number==entity.unit_number then
			pump.previousPipe=nil
		end
	end
end