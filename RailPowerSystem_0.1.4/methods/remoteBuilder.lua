addRail=function(straightRailName,curvedRailName)
	entities[railName]=railPower
	entities[curvedRailName]=railPower
end

function InitRemote()
remote.add_interface
	(ModName,
		{
			addRail=addRail,
		}
	)
end