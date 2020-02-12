require "vcl"
require "vcled.common.file"

local VCL,Form,Font,Actions,InstalledEditors = VCL,Form,Font,Actions,InstalledEditors
local file,os,table,pairs,ipairs,type,string,tostring,getfenv = file,os,table,pairs,ipairs,type,string,tostring,getfenv

module "Editors"

openedPages = {}
local tabs = nil
UID = 0

-- TODO implement canUndo, canRedo (see onEditorChange())
sheetPopupMenu = VCL.PopupMenu()
sheetPopupMenu:LoadFromTable({
	{caption="Close me", onclick="File.Close"},
	{caption="Close but me", onclick="File.CloseAllButMe"},
	{caption="Save me", onclick="File.Save"},
	{caption="Save me as...", onclick="File.SaveAs"},
	-- {caption="-"},
	-- {caption="Clone to other view",onclick=""},
})

-- return curreent Synedit, PageNo, Sheet
function GetEditor()
	if not tabs then
		return 
	end
	local n=tabs.tabindex
	if n==-1 then return end
	return n+1
end

function FindEditor(ed)
	for i,v in ipairs(openedPages) do		
		if v.Editor.tag==ed.tag then
			return i
		end
	end	
	return 
end

function GetIndex()
	if tabs then 
		return tabs.tabindex
	else
		return
	end
end

function SetIndex(v)
	if tabs then 
		tabs.tabindex = value
	end
end

function CheckEditors()
	if not tabs then return true end
	local n = table.maxn(openedPages)	
	if n==0 then
		tabs:Free()
		Actions.Disable()
		Form.mainStatusBar:Update(1,"")
		Form.mainStatusBar:Update(2,"")
		Form.mainStatusBar:Update(3,"")
		tabs = nil
	else
		for i=1,n do
			if string.find(openedPages[i].Sheet.caption,"*") then				
				return false
			end
		end		
	end
	return true
end

function onClickLink(sed, button, shift, X, Y)
	local x,y = sed:MouseToCaretPos()
    onContentHelp(sed:WordAtCursor(x,y))
end

function onSheetChanged()
	CallFunc("onInfo")
end

function onPageMouseDown(s,but,shift,x,y)
	if but=="mbRight" then 
		local x,y = VCL.GetCursorPos()
		sheetPopupMenu:Popup(x,y) 
	end
end

function ChangeEditorFont()
	local p = tabs.tabindex
	local n = table.maxn(openedPages)
	for i=1,n do
		openedPages[i].Editor.font = Font.totable(Font.editorFont.font)
	end
end

function NewEditor(f)
	
	-- create pagecontrol if not exists
	if not tabs then
		tabs = VCL.PageControl()
		tabs._ = {align="alClient", tabstop=false, onmousedown="Editors.onPageMouseDown"}
	end
	
	local n = table.maxn(openedPages)	
	
	-- file already loaded?
	for i=1,n do
		if openedPages[i].FileName == f then 
			tabs.tabindex = i-1 
			return
		end
	end

	-- add new sheet to the tabs
	table.insert(openedPages,{})
	n = n + 1
	-- add a new sheet to the pagecontrol
	local sheet = VCL.TabSheet(tabs)
	openedPages[n].Sheet = sheet
	local fn = f
	if f~=nil then
		fn = file.getname(f)
	end
	sheet._ = {caption=(fn or "New File"),onshow="Editors.onSheetChanged"}	
	InstalledEditors.CreateEditor(n,f)
	tabs.tabindex = n-1	
	-- enable actions
	Actions.EnableFileEvents()	
end

function SaveFileList()
	-- filelistconfig
	local flcname = "vcled-files.xml"
	os.remove(flcname)
	local n = 0
	if tabs then
		n = table.maxn(openedPages)
	end
	if n > 0 then
		local flc = VCL.XMLConfig()
		flc._ ={rootname = "VCLedFileList", filename = flcname}
		local fnidx=1
		for i=1,n do
			if openedPages[i].FileName then		
				flc:SetValue("File"..tostring(fnidx),openedPages[i].FileName)	
				fnidx=fnidx+1
			end
		end
		flc:Free()
	end
end

function LoadFileList()
	local i=1
	local ret = false
	local flc = VCL.XMLConfig()
    flc._ ={rootname = "VCLedFileList", filename = "vcled-files.xml"}
	while (true) do
		local fn = flc:GetValue("File"..tostring(i))
		if string.len(fn)>0 then
			ret = true
			NewEditor(fn)
			i = i + 1
		else
			break
		end
	end
	flc:Free()
	return ret
end

function CallFunc(funcName, ...)
	local n = GetEditor()	
	local env = getfenv(0)[openedPages[n].Type]
	if env then
		for k,v in pairs(env) do
			if k==funcName then 
				v(openedPages[n].Editor,...)
			end
		end
	end
end