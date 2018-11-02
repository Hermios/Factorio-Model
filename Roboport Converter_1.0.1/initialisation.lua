require "methods.roboportFunctions"
require "methods.globalEvents"

function InitGlobalData()
	listRoboport=setLocalList(global.listRoboport,RoboportPrototype,listRoboport)
	global.listRoboport=listRoboport
end