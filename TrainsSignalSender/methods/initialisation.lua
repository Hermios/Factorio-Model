require "methods.trainFunctions"
require "methods.trainStationFunctions"
require "methods.guisBuilder"
require "methods.globalEvents"
require "methods.remoteBuilder"
listTrains={}
listTrainsStop={}
global.listTrainsAtStop=global.listTrainsAtStop or {}
table.insert(ListPrototypesData,{prototype=TrainPrototype,globalData="listTrains",localData=listTrains})
table.insert(ListPrototypesData,{prototype=TrainStopPrototype,globalData="listTrainsStop",localData=listTrainsStop})