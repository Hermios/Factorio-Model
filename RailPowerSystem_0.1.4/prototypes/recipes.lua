data:extend({
    {
        type = "recipe",
        name = powerRail,
        enabled = false,
        ingredients = { { "copper-cable", 3 }, { "rail", 1 } },
        result = powerRail,
        result_count = 1,
    },
	{
        type = "recipe",
        name = railPole,
        enabled = false,
        ingredients = { { "iron-plate", 3 }, { "copper-cable", 1 },{ "electronic-circuit", 1 } },
        result = railPole,
        result_count = 1,
    },
	{
        type = "recipe",
        name = hybridTrain,
        enabled = false,
        ingredients = { { "locomotive", 1 }, { "battery", 10 }, { "electric-engine-unit", 20 } },
        result = hybridTrain,
        result_count = 1,
    },
})