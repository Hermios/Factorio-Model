require "methods.globalEvents"
require "methods.vehicleFunctions"
listVehicles={}
function InitGlobalData()
	listCustomEvents[onChangeVisibility]=OnChangeVisibility
	--[[addToVehiclesList("player",invisiblePlayer)
	addToVehiclesList("car",invisibleCar)
	addToVehiclesList("tank",invisibleTank)
	addToVehiclesList("locomotive",invisibleLocomotive)
	addToVehiclesList("artillery-wagon",invisibleArtilleryWagon)
	addToVehiclesList("cargo-wagon",invisibleCargoWagon)
	addToVehiclesList("fluid-wagon",invisibleFluidWagon)]]--
end

function addToVehiclesList(vehicleName,invisibleVehicleName)
	listVehicles[vehicleName]=invisibleVehicleName
	listVehicles[invisibleVehicleName]=vehicleName
end