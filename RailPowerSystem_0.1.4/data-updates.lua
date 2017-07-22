--[[local function insertCollisionMask(prototypeType,prototypeName,layer)
	if not data.raw[prototypeType][prototypeName] then
		return
	end
	local collision_mask=data.raw[prototypeType][prototypeName].collision_mask
	if collision_mask then
		data.raw[prototypeType][prototypeName].collision_mask=table.insert(collision_mask,layer)
	else
		data.raw[prototypeType][prototypeName].collision_mask={layer}
	end
end

insertCollisionMask("straight-rail","straight-rail","object-layer")
--insertCollisionMask("rail-signal","rail-electric-pole","object-layer")]]--

