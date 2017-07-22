entities = {}

function OnLoad()
	if not global.electricTrains then
		global.electricTrains = {}
	end	
end

function OnBuildEntity(entity)
-- remove automatic connected cables
	onGlobalBuilt(entity)
	
	if entities[entity.name] and entities[entity.name].onBuilt then
		entities[entity.name].onBuilt(entity)
	end	
end

function OnPreRemoveEntity(entity)
	if entities[entity.name] and entities[entity.name].onRemove then
		entities[entity.name].onRemove(entity)
	end	
end

function OnTick()
	for _,eTrain in pairs(global.electricTrains) do
		if eTrain and eTrain.valid and entities[eTrain.name] and entities[eTrain.name].onTick then
			entities[eTrain.name].onTick(eTrain)
		end
	end
end