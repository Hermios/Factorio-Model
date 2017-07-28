trainEntity.CanOpenGui=function(entity)
	if player.force.technologies[trainSignalSenderTech].researched and not global.trains then
		global.trains={}
	end
	return global.trains
end

trainEntity.UpdateGui=function(entity)
	local locoFrame=getFrame(LeftGui,entity)
	if not global.trains then
		return
	end
	if not global.trains[entity.train.id] then
		global.trains[entity.train.id]={}
		return
	end
	if not global.trains[entity.train.id].signals then
		return
	end
	for i=1,SignalsFrameDimension do
		for j=1,SignalsFrameDimension do	
			signalData=global.trains[entity.train.id].signals[i.."."..j]
			if signalData then
				guiElementEntities["signal."..i.."."..j].Set(signalData.signal)
				getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption=signalData.count
			end
		end
	end
end

trainEntity.UpdateFromGui=function(entity)
	if not global.trains[entity.train.id] then
		global.trains[entity.train.id]={}
	end
	global.trains[entity.train.id].signals={}
	for i=1,SignalsFrameDimension do
		for j=1,SignalsFrameDimension do				
			if guiElementEntities["signal."..i.."."..j].value and type(guiElementEntities["signal."..i.."."..j].value)=="table" then	
				global.trains[entity.train.id].signals[i.."."..j]=
				{
					signal=guiElementEntities["signal."..i.."."..j].value,
					count=tonumber(getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption) or 1,
					index=tonumber(i+j-1)
				}
				getFrame(LeftGui,{entity,"Row."..i,"signalQuantity."..i.."."..j}).caption=global.trains[entity.train.id].signals[i.."."..j].count
			end
		end
	end
	OnTrainStateChanged(entity.train)
end