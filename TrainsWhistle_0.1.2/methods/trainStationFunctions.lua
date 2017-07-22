stationItems={}
local function getNetworkGhosts(network)
	local ghostItems={}
	local result={}
	for _,cell in pairs(network.cells) do		
		local cellArea={{cell.owner.position.x-cell.construction_radius,cell.owner.position.y-cell.construction_radius},{cell.owner.position.x+cell.construction_radius,cell.owner.position.y+cell.construction_radius}}
		for _,ghostEntity in pairs(game.surfaces[1].find_entities_filtered{area=cellArea,type="entity-ghost"}) do
			local itemName=getFirstKey(ghostEntity.ghost_prototype.items_to_place_this)
			ghostItems[itemName]=(ghostItems[itemName] or 0)+1		
		end			
	end
	--if more items are required as those available, add the item to the list
	for item,quantity in pairs (ghostItems) do
		if quantity>network.get_item_count(item) then				
			table.insert(result,item)
		end
	end
	return result
end

function getStationRequiredItems()
	stationItems={}
	for index,stationData in pairs(global.trainStations) do
		if stationData.station and stationData.station.valid then
			stationItems[stationData.station.unit_number]={}
			if stationData.networkCallActivated then
				local network =game.surfaces[1].find_logistic_network_by_position(stationData.station.position,stationData.station.force)
				if network then
					local ghosts=getNetworkGhosts(network)
					if #ghosts>0 then				
						stationItems[stationData.station.unit_number]=ghosts
					end
				end
			end
			if stationData.circuitCallActivated and stationData.circuitConditions then
				local greenCircuit=stationData.station.get_circuit_network(defines.wire_type.green)
				local redCircuit=stationData.station.get_circuit_network(defines.wire_type.red)
				for _,circuitCondition in pairs(stationData.circuitConditions) do
					if circuitCondition.signal1 and circuitCondition.signal2 then
						local quantity1=greenCircuit.get_signal(circuitCondition.signal1) + redCircuit.get_signal(circuitCondition.signal1)
						local quantity2=tonumber(circuitCondition.signal2) or (greenCircuit.get_signal(circuitCondition.signal2) + redCircuit.get_signal(circuitCondition.signal2))
						if compareData(circuitCondition.comparator,quantity1,quantity2) then
							table.insert(stationItems[stationData.station.unit_number],circuitCondition.resultSignal.name)
						end
					end
				end
			end
		else
			global.trainStations[index]=nil
		end
	end
end

