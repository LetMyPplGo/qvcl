require "vcl"
require "vcled.editors"
require "vcled.preferences"
require "vcled.common.file"
require "vcled.editors.installededitors"

local VCL,Editors,Form,Preferences,InstalledEditors = VCL,Editors,Form,Preferences,InstalledEditors
local file,type,table,pairs,string = file,type,table,pairs,string

module "File"

function New()
	Editors.NewEditor(nil)
end

function Open()
	fod = VCL.OpenDlg()	
	
	local filename = fod:Execute(
		{ title="Open file(s)",
		  initialdir="./",
		  filter=table.concat(InstalledEditors.fileFilter,"|"),
		  options="[ofAllowMultiSelect, ofFileMustExist, ofViewDetail]"
		}) 
	fod:Free()
	if type(filename)=="table" then
		for k,v in pairs(filename) do
			Editors.NewEditor(v)
		end
	elseif type(filename)=="string" then	
		Editors.NewEditor(filename)
	end
end

function Save()
	local n = Editors.GetEditor()
	local fn = Editors.openedPages[n].FileName
	local s = Editors.openedPages[n].Sheet
	if not file.exists(fn) then
		return SaveAs()
	else
		Editors.CallFunc("onSave",fn)
	end
	s.caption = string.gsub(s.caption,"*","")
	return true
end

function SaveAs()
	local n = Editors.GetEditor()
	local fn = Editors.openedPages[n].FileName
	local sad = VCL.SaveDlg()
	local filename = sad:Execute(
					{ title="Save file as...",
					  filename=fn,
					  initialdir="./",
					  filter=table.concat(InstalledEditors.fileFilter,"|"),
					  options="[ofViewDetail]"
					}) 		
	sad:Free()
	if filename == nil then
		return false
	else
		if file.exists(filename) then
			if VCL.MessageDlg("File already exists on disk. Do you want to replace it?\n\n"..filename,"mtConfirmation",{"mbYes","mbNo"})=="mrNo" then
				return false
			end
		end
		Editors.CallFunc("onSave",filename)		
		Editors.openedPages[n].FileName = filename
		Editors.openedPages[n].Sheet.caption = file.getname(filename)
		return true
	end
end

function SaveAll()
	local n = Editors.GetEditor()
	local p = Editors.GetIndex()
	for i=1,n do
		Editors.SetIndex(i-1)
		Save()
	end
	Editors.SetIndex(p)
end

function Close()
	local n = Editors.GetEditor()
	local s = Editors.openedPages[n].Sheet
	if string.find(s.caption,"*") then
		local answ = VCL.MessageDlg("Save file "..s.caption.." ?","mtConfirmation",{"mbYes","mbNo","mbCancel"})
		if answ =="mrCancel" then
			return false
		elseif answ == "mrYes" then
			if not Save() then
				return false
			end			
		end
	end
	s:Free()
	table.remove(Editors.openedPages,n)
	Editors.CheckEditors()
	return true
end

function CloseAll()
	local n = Editors.GetEditor()	
	while n>0 do
		Editors.SetIndex(n-1)
		if not Close() then
			return
		end
		local n = Editors.GetEditor()
		if table.maxn(Editors.openedPages)==0 then
			return
		end
	end
end

function CloseAllButMe()
    local n = Editors.GetEditor()
    local m = table.maxn(Editors.openedPages)
    for i=1,n-1 do
		Editors.SetIndex(0)
		if not Close() then
		  return
	   end
	end
	m=table.maxn(Editors.openedPages)
	for i=2,m do
		Editors.SetIndex(1)
		if not Close() then
		  return
	   end
	end
end

function Print()
	Editors.CallFunc("onPrint")
end

function Exit()
	Form.mainForm:Close()
end

function CloseQuery(Sender)
	local ret = false
	if not Editors.CheckEditors() then
		if VCL.MessageDlg("You have unsaved file(s). Continue?","mtConfirmation",{"mbYes","mbCancel"})=="mrYes" then
			ret = true
		end
	else
		if Form.mainConfig:GetValue("ConfirmExit")~="true" then
			ret = true
		elseif VCL.MessageDlg("Are you sure?","mtConfirmation",{"mbYes","mbCancel"})=="mrYes" then
			ret = true
		end
	end
	return ret
end

function DropFiles(sender,f)
	if type(f)=="table" then
		for k,v in pairs(f) do
			Editors.NewEditor(v)
		end
	elseif type(f)=="string" then
		Editors.NewEditor(f)
	end
end
