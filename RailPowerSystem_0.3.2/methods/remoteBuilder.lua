addRail=function(straightRailName,curvedRailName)
	railType[straightRailName]="straight"
	railType[curvedRailName]="curved"
end

addLocomotive=function(locomotiveName)
	locomotiveType[locomotiveName]="electric"
end

function InitRemote()
	remote.add_interface
	(ModName,
		{
			addRail=addRail,
			addLocomotive=addLocomotive
		}
	)
	if remote.interfaces.farl then
		remote.call("farl", "add_entity_to_trigger", electricStraightRail)
		remote.call("farl", "add_entity_to_trigger", electricCurvedRail)
	end
end