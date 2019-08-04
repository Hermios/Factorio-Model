for _,entity in pairs(game.surfaces[1].find_entities_filtered{name="rail-pole-connector"}) do
	entity.destructible=true 
	entity.minable=true 
end