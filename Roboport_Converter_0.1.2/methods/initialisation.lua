require "methods.roboportFunctions"
require "methods.globalEvents"

function InitGlobalData()
	listRoboport=setLocalList(global.listRoboport,RoboportPrototype)
	global.listRoboport=listRoboport
end