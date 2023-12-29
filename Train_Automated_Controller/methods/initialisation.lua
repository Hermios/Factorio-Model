require "methods.TACFunctions"
require "methods.guisBuilder"
require "methods.globalEvents"
require "methods.PrototypeConditions"
require "methods.PrototypeActions"
require "methods.remoteBuilder"
require "methods.localFunctions"

listTAC={}
table.insert(ListPrototypesData,{prototype=TACEntity,globalData="listTAC",localData=listTAC})

function initLocalData()
	for _,condition in pairs(getLocalConditionsList()) do
		addToConditions(condition)
	end
	for _,action in pairs(getLocalActionsList()) do
		addToActions(action)
	end
end
