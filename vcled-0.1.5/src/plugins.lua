require "vcl"
require "vcled.common.file"

local VCL,file = VCL,file
local table,string,tonumber,getfenv,dofile,loadstring,ipairs,pairs,type = table,string,tonumber,getfenv,dofile,loadstring,ipairs,pairs,type

module "Plugins"
	
local plugDesc = "plugins/plugins.xml"

function Load()
	if not plugmanForm then
		plugmanForm = VCL.Form()
		plugmanForm._  = {caption="Managed plugins", position="pomainformcenter", height=400, width=700, borderstyle="bsdialog"} -- formstyle="fsStayOnTop", 
		local plugmanPanel = VCL.Panel(plugmanForm)
		plugmanPanel._  = {caption="", align="alBottom", height=34, bevelouter="bvLovered", bevelinner="bvLowered"}
		local ooButton = VCL.Button(plugmanPanel)
		ooButton._ = { caption="On/Off", left=20, top=5, width=100, onclick="Plugins.onSetOnOff"}
		local addButton = VCL.Button(plugmanPanel)
		addButton._ = { caption="Add", left=150, top=5, width=100, onclick="Plugins.onAdd"}
		local removeButton = VCL.Button(plugmanPanel)
		removeButton._ = { caption="Remove", left=280, top=5, width=100, onclick="Plugins.onRemove"}
		local saveButton = VCL.Button(plugmanPanel)
		saveButton._ = { caption="Save", left=410, top=5, width=100, onclick="Plugins.onSave"}
		local cancelButton = VCL.Button(plugmanPanel)
		cancelButton._ = { caption="Close", left=540, top=5, width=100, onclick="Plugins.onCancel"}
	end
	if not plugGrid then
		plugGrid = VCL.StringGrid(plugmanForm)
		plugGrid._ = {align="alClient",fixedcols=0,fixedrows=1,colcount=2,rowcount=1, options = "[goRowSelect,goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine]"}
		plugGrid:SetColParams({
			{width=40, title={caption="Active"}, readonly=true, buttonstyle="cbsCheckboxColumn"},
			{width=100, title={caption="Name"}, readonly=true},
			{width=50, title={caption="Type"}, readonly=true},
			{width=50, title={caption="Version"}, readonly=true},
			{width=360, title={caption="Filename"}, readonly=true},
			{width=80, title={caption="VCLed version"}, readonly=true},
		})
		local r=1
		local t = nil
		if file.exists(plugDesc) then
			t=file.loadastable(plugDesc)
		end
		if t then
		for i,v in ipairs(t) do
			for k,w in string.gmatch(v,"(%w+)=\"(%d+)\"") do
				if k=="rowcount" then 
					r=tonumber(w)
					break
				end
			end
		end
		end
		plugGrid.rowcount=r
		if r>1 and file.exists(plugDesc) then
			plugGrid:LoadFromFile(plugDesc)	
		end		
	end
end

function Init(t)
	if t and t[1]=="1" then
		if not getfenv(0)[t[2]] then
			dofile(t[5])			
		end
		loadstring(t[2]..".Init()")()
	end
end

function Stop(t)
	if t and tonumber(t[1])==1 then
		if getfenv(0)[t[2]] then
			loadstring(t[2]..".Stop()")()
		end
	end
end

function onSetOnOff()
	local c,r = plugGrid:SelectedCell()
	local o = tonumber(plugGrid:GetCell(0,r))
	if o<1 then 
		plugGrid:SetCell(0,r,1)
		Init(plugGrid:RowToTable(r))
	else 
		Stop(plugGrid:RowToTable(r))
		plugGrid:SetCell(0,r,0)
	end
end

function onManagePlugins()
	Load()
	plugmanForm:ShowModal()
end

function AddToPluginList(f)
	local t=nil
	for i=1,plugGrid.rowcount-1 do
		t=plugGrid:RowToTable(i)
		if t[5]==f then
			VCL.ShowMessage(string.format("Plugin already added!\nPlugin: %s",t[2]))
			return
		end
	end
	local pi = dofile(f)	
	if pi then
		plugGrid.rowcount=plugGrid.rowcount+1
		plugGrid:LoadRowFromTable(plugGrid.rowcount-1,{0,pi.name,pi.type,pi.version,f,pi.VCLedversion})
	else
		VCL.ShowMessage(string.format("Invalid plugin information!\nFile: %s",file.getname(f)))
	end
end

function onAdd()
	local fileopenoptions = {"ofAllowMultiSelect", "ofFileMustExist", "ofViewDetail"}
	local fod = VCL.OpenDlg()
	local filename = fod:Execute(
					{ title="Open Plugin",
					  initialdir="./",
					  filter="Plugins (*.lua)|*.lua",
					  options="[ofAllowMultiSelect, ofFileMustExist, ofViewDetail]"
					}) 
	fod:Free()
	if type(filename)=="table" then
		for k,v in ipairs(filename) do
			if v ~= nil then
				AddToPluginList(v)
			end
		end	
	else
		if filename ~= nil then
			AddToPluginList(filename)
		end
	end
end

function onRemove()
	local c,r = plugGrid:SelectedCell()
	if r>0 then
		Stop(plugGrid:RowToTable(r))
		plugGrid:DeleteColRow(false,r)
	end
end

function onSave()
    plugGrid:SaveToFile(plugDesc)
end

function onCancel()
	plugmanForm:Close()
end

function AutoLoad()
	Load()
	if plugGrid then
		for i=1,plugGrid.rowcount-1 do
			local t=plugGrid:RowToTable(i)
			Init(t)
		end
	end
end

function Unload()
	Load()
	if plugGrid then
		for i=1,plugGrid.rowcount-1 do
			local t=plugGrid:RowToTable(i)
			Stop(t)
		end
	end
end
