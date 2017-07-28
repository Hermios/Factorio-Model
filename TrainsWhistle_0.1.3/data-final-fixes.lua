require "constants"
for locoName, loco in pairs(data.raw.locomotive) do
	if not loco.equipment_grid then
		loco.equipment_grid=trainWhistleEquipmentGrid
	end
	if loco.equipment_grid~=trainWhistleEquipment then
		local equipmentGrid=data.raw["equipment-grid"][loco.equipment_grid]
		local existing=false
		local i=1
		while not existing and i<#equipmentGrid.equipment_categories do
			existing = equipmentGrid.equipment_categories[i]==trainWhistleEquipment
			i=i+1
		end
		if not existing then
			table.insert(equipmentGrid.equipment_categories,trainWhistleEquipment)
		end
	end
end