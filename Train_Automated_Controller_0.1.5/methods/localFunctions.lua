function setListTrainsStops(guiElement)
	for _,trainStop in pairs(game.surfaces[1].find_entities_filtered{name="train-stop"}) do
		guiElement.add_item(trainStop.backer_name)
	end
end