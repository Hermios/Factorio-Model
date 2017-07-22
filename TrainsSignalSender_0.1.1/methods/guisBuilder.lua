local function initLocomotiveGui()
	GuiEntities["locomotive"]={type="frame",name="trainSignalSender",direction="vertical",caption={"train-signal-sender"},children={}}
	for i=1,SignalsFrameDimension do
		local RowFrame={type="flow",name="Row."..i,direction="horizontal",style="slot_table_spacing_flow_style",children={}}
		table.insert(GuiEntities["locomotive"].children,RowFrame)
		for j=1,SignalsFrameDimension do
			table.insert(RowFrame.children,SignalButton.new("signal."..i.."."..j,nil,nil,true))
			table.insert(RowFrame.children,{type="label",name="signalQuantity."..i.."."..j,caption=" "})			
		end
	end
	table.insert(GuiEntities["locomotive"].children,{type="textfield",name="quantityLabel",style="number_textfield_style"})		
end

function InitGuiBuild()			
	initLocomotiveGui()
end