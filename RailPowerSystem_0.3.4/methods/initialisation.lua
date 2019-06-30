require "methods.railPoleConnectorFunctions"
require "methods.trainFunctions"
require "methods.railFunctions"
require "methods.globalEvents"
require "methods.remoteBuilder"

listTrains={}
listRails={}
listRailPoleConnectors={}
table.insert(ListPrototypesData,{prototype=TrainPrototype,globalData="listTrains",localData=listTrains})
table.insert(ListPrototypesData,{prototype=RailPrototype,globalData="listRails",localData=listRails})
table.insert(ListPrototypesData,{prototype=RailPoleConnectorPrototype,globalData="listRailPoleConnectors",localData=listRailPoleConnectors})