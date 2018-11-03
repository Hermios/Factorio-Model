require "methods.trainFunctions"
require "methods.trainStopFunctions"
require "methods.globalEvents"

function InitGlobalData()
	listTrains=setLocalList(global.listTrains,TrainPrototype)
	global.listTrains=listTrains
end

function InitData()
	listCustomEvents[onTrainWhistled]=OnTrainWhistled
end