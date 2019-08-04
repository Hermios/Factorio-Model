data:extend({
    {
        type = "recipe",
        name = electricRail,
        enabled = false,
        ingredients = { { "copper-cable", 3 }, { "rail", 1 } },
        result = electricRail,
        result_count = 1,
    },
	{
        type = "recipe",
        name = prototypeConnector,
        enabled = false,
        ingredients = { { "iron-plate", 3 }, { "copper-cable", 1 },{ "electronic-circuit", 1 } },
        result = prototypeConnector,
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