require "methods.trainFunctions"
require "methods.trainStopFunctions"
require "methods.globalEvents"

listTrains={}
listTrainStops={}
table.insert(ListPrototypesData,{prototype=TrainPrototype,globalData="listTrains",localData=listTrains})
table.insert(ListPrototypesData,{prototype=TrainStopPrototype,globalData="listTrainStops",localData=listTrainStops})

function InitListCustomEvents()
	listCustomEvents[onTrainWhistled]=OnTrainWhistled
end