function OnChangeVisibility(event,entity)

(player.vehicle or player.character or {}).color={r = 0, g = 0, b = 0, a = 0.1}
	
	--[[local entity=entity or player.character.vehicle or player.character
	local newPrototype=VehiclePrototype:new(entity)
	if newPrototype then
		newPrototype:changeVisibility()
		for _,force in pairs(game.forces) do
			if force~=newPrototype.entity.force then
				force.set_cease_fire(newPrototype.entity.force,ListInvisibleEntities[newPrototype.entity.unit_number]==true)
			end
		end
	end]]--
end