setSignals= function (train,signals)
	if not global.trains then
		return
	end
	local isEmpty=false
	if not global.trains[train.id] or not global.trains[train.id].signals then
		global.trains[train.id]={signals={}}
		isEmpty=true
	end
	if signals.item then
		signals={signals}
	end
	for _,signalData in pairs(signals) do
		local i=1
		local j=1
		local itemFound=nil
		local emptyCell=nil
		if isEmpty==true then
			emptyCell={i=1,j=1}
		else
			while i<=SignalsFrameDimension and not itemFound==false do
				while j<=SignalsFrameDimension and not itemFound==false do					
					if not global.trains[train.id].signals[i.."."..j] or not global.trains[train.id].signals[i.."."..j].signal or type(global.trains[train.id].signals[i.."."..j].signal)=="string" then
						if not emptyCell then
							emptyCell={i=i,j=j}
						end
					else
						itemFound=global.trains[train.id].signals[i.."."..j]
					end 
					j=j+1
				end
				i=i+1
			end
		end
		if not itemFound then	
			if emptyCell then
				global.trains[train.id].signals[emptyCell.i.."."..emptyCell.j]=
				{
					signal=signalData.signal,
					count=signalData.count,
					index=tonumber(emptyCell.i+emptyCell.j-1)
				}
			end
		else
			itemFound.count=signalData.count
		end
	end
	OnTrainStateChanged(train)
end

clearSignals= function (train)
	if not global.trains then
		return
	end
	global.trains[train.id]=nil
	OnTrainStateChanged(train)
end

addTrainStop=function(trainStopName)
	entities[trainStopName]=trainStopEntity
end

function InitRemote()
remote.add_interface
	(ModName,
		{
			setSignals=setSignals,
			clearSignals=clearSignals,
			addTrainStop=addTrainStop
		}
	)
end