require "methods.trainFunctions"
require "methods.trainStationFunctions"
require "methods.guisBuilder"
require "methods.globalEvents"

listTrains={}
listTrainsStop={}
table.insert(ListPrototypesData,{prototype=TrainPrototype,globalData="listTrains",localData=listTrains})
table.insert(ListPrototypesData,{prototype=TrainStopPrototype,globalData="listTrainsStop",localData=listTrainsStop})