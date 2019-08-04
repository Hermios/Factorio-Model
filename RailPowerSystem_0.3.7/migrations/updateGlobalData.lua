for key,value in pairs(global.listTrains) do
	global.listTrains[key]=global.listTrains[key].guiData or value
end

for key,value in pairs(global.listRails) do
	global.listRails[key]=global.listRails[key].guiData or value
	for i,node in pairs(global.listRails[key].circuitNodes or {}) do
		if i>1 then
			node.destroy()
		else
			global.listRails[key].railNode=node
		end
	end
	global.listRails[key].railNode.disconnect_neighbour()
	global.listRails[key]:connectToRail()
	global.listRails[key]:connectToRailPoleConnector()
end

for key,value in pairs(global.listRailPoleConnectors) do
	global.listRailPoleConnectors[key]=global.listRailPoleConnectors[key].guiData or value
	if global.listRailPoleConnectors[key].groundNode then
		global.listRailPoleConnectors[key].groundNode.destroy()
	end
	if global.listRailPoleConnectors[key].railNode then
		global.listRailPoleConnectors[key].railNode.destroy()
	end
	if global.listRailPoleConnectors[key].prototypeEntity then
		global.listRailPoleConnectors[key].prototypeEntity.destroy()
	end
	global.listRailPoleConnectors[key]:connectToRail()
end