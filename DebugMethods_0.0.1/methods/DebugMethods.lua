function InitData()
commands.add_command("GetEntitiesChar","Get Entitiers Around Character(Default, 5)",
	function(dista)
		if not dist then
		dist=5
		end
		local position=player.position
		for _,surface in pairs(game.surfaces) do
			for _,entity in pairs(surface.find_entities_filtered{area={{position.x-dist,position.y-dist},{position.x+dist,position.y+dist}}}) do
				player.print(entity.name)
			end
		end
	end)
commands.add_command("ClearItem","Clear Item Around Character(Item, distance)",
	function(item,dista)
	player.print(item)
		if not dist then
		dist=5
		end
		local position=player.position
		for _,surface in pairs(game.surfaces) do
			for _,entity in pairs(surface.find_entities_filtered{area={{position.x-dist,position.y-dist},{position.x+dist,position.y+dist}}}) do
				if entity.name==item then
					entity.destroy()
				end
			end
		end
	end)

end