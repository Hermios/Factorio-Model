constantCombinatorEntity={}
eventsControl["constant-combinator"]=constantCombinatorEntity

constantCombinatorEntity.OnBuilt=function(entity)
	if entity.name==AutoIncrementCombinator then
		entity.operable=false
		entity.get_or_create_control_behavior().set_signal(1,{count=global.Index,signal={type="virtual",name=AicSignal}})
		global.Index=global.Index+1
	end
end