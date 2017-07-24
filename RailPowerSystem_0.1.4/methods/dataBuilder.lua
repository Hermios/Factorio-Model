function InitData()
basePowerMax=game.entity_prototypes["hybrid-train"].max_energy_usage + 10
	if remote.interfaces.farl then
		remote.call("farl", "add_entity_to_trigger", straightRailPower)
		remote.call("farl", "add_entity_to_trigger", curvedRailPower)
	end
	if not global.electricTrains then
		global.electricTrains = {}
	end	
end