--declaration arrays
guiElementEntities["quantityLabel"]={}

OnSignalSelected=function(signalName)
	local i,j=string.match(getCurrentSelectedSignalName(),"signal%.(%d+)%.(%d+)")
	if not i or not j then
		return
	end
	local entity=player.opened
	getFrame(LeftGui,{entity,"quantityLabel"}).text=getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption
end

guiElementEntities["quantityLabel"].OnChangedText=function(entity,element)
	local i,j=string.match(getCurrentSelectedSignalName(),"signal%.(%d+)%.(%d+)")
	if not i or not j then
		return
	end
	local intQuantity=tonumber(element.text)
	if not intQuantity then
		return
	end
	getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption=element.text
	--in case of no quantity, the signal is removed
	if element.text=="0" then
		guiElementEntities["signal."..i.."."..j].Set(nil)
		getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption=" "
	end
	OnUpdateFromGui()
end