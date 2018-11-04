require "methods.trainFunctions"
require "methods.trainStopFunctions"
require "methods.globalEvents"

function InitGlobalData()
	listTrains=setLocalList(global.listTrains,TrainPrototype)
	global.listTrains=listTrains
	listTrainStops=setLocalList(global.listTrainStops,TrainStopPrototype)
	global.listTrainStops=listTrainStops
end

function InitData()
	listCustomEvents[onTrainWhistled]=OnTrainWhistled
end