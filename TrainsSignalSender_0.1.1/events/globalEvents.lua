function OnTrainStateChanged(train)
	if not global.trains then
		return
	end
	if not train or not train.valid then
		if global.trains[train.id] then
			global.trains[train.id]=nil
		end
		return
	end
	if not global.trains[train.id] or not global.trains[train.id].signals then
		return
	end
	if not train.station  then
		if global.trains[train.id].station and global.trains[train.id].station.valid and entities[global.trains[train.id].station.name] then
			getConstantCombinator(global.trains[train.id].station).get_or_create_control_behavior().parameters=nil
		end
		global.trains[train.id].station=nil
	elseif entities[train.station.name] then
		global.trains[train.id].station=train.station
		for _,data in pairs(global.trains[train.id].signals) do
			if data and type(data)=='table' and data.signals then
				i=i+1
				table.insert(signals,{signal=data.signals.signal,count=signal.quantity,index=i})	
			end
		end				
		getConstantCombinator(global.trains[train.id].station).get_or_create_control_behavior().parameters={ parameters=global.trains[train.id].signals }
	end
end

OnTrainBuilt=function(train)
	if global.trains then
		global.trains[train.id]={}
	end
end

trainStopEntity.OnBuilt=function(entity)
	getConstantCombinator(entity)
end

trainStopEntity.OnRemoved=function(entity)	
	getConstantCombinator(entity).destroy()
end

function getConstantCombinator(entity)
	if not entity or not entity.valid then
	return nil
	end
	local x=entity.position.x
	local y=entity.position.y
	constantCombin= game.surfaces[1].find_entities_filtered{area={{x-0.5,y-0.5},{x+0.5,y+0.5}},name="ghost-constant-combinator"}[1]
	if not constantCombin then
	constantCombin = entity.surface.create_entity({name="ghost-constant-combinator",position=entity.position,force=entity.force})
	constantCombin.operable = false
	constantCombin.minable = false
	constantCombin.destructible = false
	entity.connect_neighbour{wire=defines.wire_type.green,target_entity=constantCombin}
	entity.connect_neighbour{wire=defines.wire_type.red,target_entity=constantCombin}
	end
	return constantCombin
end