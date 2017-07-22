function getConstantCombinator(entity)
local x=entity.position.x
local y=entity.position.y
	return game.surfaces[1].find_entities_filtered{area={{x-0.5,y-0.5},{x+0.5,y+0.5}},name="ghost-constant-combinator"}[1]
end