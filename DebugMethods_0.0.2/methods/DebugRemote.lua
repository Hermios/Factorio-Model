local function recursiveData(data,prefix)
	if not prefix then prefix="" else prefix=prefix..":" end
	local result={}
	for i,d in pairs(data) do
		if type(d)=="table" then			
			local subResult=recursiveData(d,prefix..i)
			for _,src in pairs(subResult) do
				table.insert(result,src)
			end
		else
			table.insert(result,prefix..i..":"..tostring(d))
		end
	end
	return result
end

local function printTableContent(data)
	local result=recursiveData(data)
	for _,d in pairs(result) do
		player.print(d)
	end
end

function InitRemote()
	remote.add_interface
	(ModName,
		{
			printTableContent=printTableContent
		}
	)
end