for _, force in pairs(game.forces) do
    force.reset_recipes()
    force.reset_technologies()

    local techs = force.technologies
    local recipes = force.recipes
    if techs["circuit-network"].researched then
        recipes["Auto Increment Combinator Recipe"].enabled = true
    end
end
