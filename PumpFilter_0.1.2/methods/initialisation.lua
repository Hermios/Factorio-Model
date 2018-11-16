require "methods.constants"
require "methods.fluidFunctions"
require "methods.guisBuilder"
require "methods.globalEvents"

function InitGlobalData()
	listPumps=setLocalList(global.listPumps,PumpPrototype)
	global.listPumps=listPumps
end

function InitData()
	for _,pump in pairs(game.surfaces[1].find_entities_filtered{type="pump"}) do
		listPumps[pump.unit_number]=listPumps[pump.unit_number] or PumpPrototype:new(pump)
	end
	
end