addRail=function(straightRailName,curvedRailName)
	entities[straightRailName].methods=railPower
	railType[straightRailName]="straight"
	entities[curvedRailName].methods=railPower
	railType[curvedRailName]="curved"
end

function InitRemote()
remote.add_interface
	(ModName,
		{
			addRail=addRail,
		}
	)
end