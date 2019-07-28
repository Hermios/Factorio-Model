function InitRemote()
remote.add_interface
	(ModName,
		{
			addToConditions,
			removeFromCondition,
			addToActions,
			removeFromAction
		}
	)
end