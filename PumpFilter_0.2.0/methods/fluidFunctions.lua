PumpPrototype={}
function PumpPrototype:new (entity)
	if entity.valid==false then
		return nil
	end
	local o= 
	{
		globalData=
		{
			entity=entity
		}
	}
	setmetatable(o, self)
	global.listPumps[entity.unit_number]=o.globalData
	return o
end