require "methods.railPoleConnectorFunctions"
require "methods.trainFunctions"
require "methods.railFunctions"
require "methods.globalEvents"

function InitGlobalData()
	listTrains=setLocalList(global.listTrains,TrainPrototype)
	global.listTrains=listTrains
	listRails=setLocalList(global.listRails,RailPrototype)
	global.listRails=listRails
	listRailPoleConnectors=setLocalList(global.listRailPoleConnectors,RailPoleConnectorPrototype)
	global.listRailPoleConnectors=listRailPoleConnectors
end

function InitData()
	railType[electricStraightRail]="straight"
	railType[electricCurvedRail]="curved"
	locomotiveType[hybridTrain]=true
	if remote.interfaces.farl then
		remote.call("farl", "add_entity_to_trigger", electricStraightRail)
		remote.call("farl", "add_entity_to_trigger", electricCurvedRail)
	end
end