local function recursiveData(data,prefix)
	if not prefix then prefix="" else prefix=prefix.."->" end
	local result={}
	for i,d in pairs(data) do
		if type(d)=="table" then			
			local subResult=recursiveData(d,prefix..i)
			for _,src in pairs(subResult) do
				table.insert(result,src)
			end
		else
			table.insert(result,prefix..i.."->"..tostring(d))
		end
	end
	return result
end

remote.add_interface("Debug",
	{
		printData=function (data,prefix)
			if not prefix then prefix="" else prefix=prefix..":" end
			if not data then 
				game.players[1].print(prefix.."no data")
			elseif type(data)~="table" then
				game.players[1].print(prefix..tostring(data))
			else
				local result=recursiveData(data)
				local hasData=false
				for _,d in pairs(result) do
					hasData=true
					game.players[1].print(prefix..d)
				end
				if not hasData then
					game.players[1].print(prefix.."empty table")
				end
			end
		end
	}
)
