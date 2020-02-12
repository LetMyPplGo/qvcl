require "vcl"
require "lfs"

-- globals to see
local os,string,table,type,pairs,ipairs,unpack = os,string,table,type,pairs,ipairs,unpack
local VCL,Editors,lfs,mainImages,mainMenu,mainActions,file = VCL,Editors,lfs,mainImages,mainMenu,mainActions,file


-- ************************************************************************
module "LuaRunnerPlugin"

pluginInfo={
	name="LuaRunnerPlugin", 
	type="Main",
	version="1.2",
	VCLedversion="0.1.5",
	pluginMenuId="luarunnerplg01",
	path = "plugins/lua-runner.v1.2"
}

runForm = nil

-- internal
local iconFileName= pluginInfo.path.."/run.png"
local mmenuId="mmplugins"     -- mainmenu item
local mmenuIdx=3             -- mainmenu index (for insert)
local menuIdx=0              -- insert as first menuitem

local runFileEdit=nil
local runDirEdit=nil
local runPageControl=nil
local oldDir="./"

local scriptName=""
local scriptArgs={}

function CreateForm()
	runForm = VCL.Form()
	runForm._  = {caption="Lua Script Runner "..pluginInfo.version, position="pomainformcenter", height=350, width=600, borderstyle="bsdialog" } -- formstyle="fsStayOnTop", }	
	local luaRunDataPanel = VCL.Panel(runForm)
	luaRunDataPanel._  = {caption="", align="alClient", bevelouter="bvLowered", bevelinner="bvRaised"}
	VCL.Label(luaRunDataPanel)._ = {caption="Script to run",left=10,top=10}
	runFileEdit = VCL.FileNameEdit(luaRunDataPanel)
	runFileEdit._ = {filename=scriptName,width=470, left=100,top=8, tabstop=true}
	VCL.Label(luaRunDataPanel)._ = {caption="Working dirwctory",left=10,top=40}
	runDirEdit = VCL.DirectoryEdit(luaRunDataPanel)
	runDirEdit._ = {directory=file.getpath(scriptName),width=470, left=100,top=38, tabstop=true}
	runForm.runPageControl = VCL.PageControl(runForm)
	runForm.runPageControl._ = {top=70, left=10, width=580, height=240}
	for i,v in ipairs({"Output", "Params"}) do
	    runForm.runPageControl[i] = VCL.TabSheet(runForm.runPageControl)
         runForm.runPageControl[i]._ = {caption=v}
	end	
	runForm.runOutMemo = VCL.ListBox(runForm.runPageControl[1])
	runForm.runOutMemo._ = {align="alClient", items={}, font={name="Courier New", size=9}}
	runForm.runParamsMemo = VCL.Memo(runForm.runPageControl[2])
	runForm.runParamsMemo._ = {align="alClient", lines={}, font={name="Courier New", size=10, color=VCL.clBlue}} -- bug?
	runForm.runParamsMemo:Clear()	
	local luarunButPanel = VCL.Panel(runForm,"luarunButPanel")
	luarunButPanel._  = {caption="", align="alBottom", height=30, bevelouter="bvLovered", bevelinner="bvNone"}	
	VCL.Button(luarunButPanel,"luarunButPanelB1")._ = {caption="Run", left=20, width=100, top=3, onclick="LuaRunnerPlugin.onRunSeparate"}
	VCL.Button(luarunButPanel,"luarunButPanelB3")._ = {caption="Clear", left=230, width=100, top=3, onclick="LuaRunnerPlugin.onClear"}	
	VCL.Button(luarunButPanel,"luarunButPanelB2")._ = {caption="Close", left=480, width=100, top=3, onclick="LuaRunnerPlugin.onClose"}		
end

function ShowRunForm()
	local n = Editors.GetEditor()
	scriptName = Editors.openedPages[n].FileName or ""
	if not runForm then CreateForm() end	
	runFileEdit.filename=scriptName
	runForm:ShowModal()
end

function onRunSeparate()
	oldDir = lfs.currentdir()
	lfs.chdir(runDirEdit.directory)
	scriptName = runFileEdit.filename
    scriptArgs = runForm.runParamsMemo:GetText() or {}
	local result = VCL.RunSeparate(table.maxn(scriptArgs),scriptName,unpack(scriptArgs))
	
    if table.maxn(result)==1 then
		local t = string.gsub(result[1],"%\t","     ")
		runForm.runOutMemo:SetText(t)
     else
        runForm.runOutMemo:SetText(result)
     end

	runForm.runPageControl.tabindex=0
	lfs.chdir(oldDir)
end

function onClear()
	runForm.runOutMemo:Clear()
end

function onClose()
	runForm:Close()
end

-- ********************************
-- Script initialization
-- ********************************

function Init()
	local ii = mainImages:LoadFromFile(iconFileName)
	mainActions:LoadFromTable({{name="runLuaPluginsAction", shortcut="F5", caption="Run Lua script...", imageindex=ii, onexecute="LuaRunnerPlugin.ShowRunForm"}})	
	local plug1 = mainMenu:Find(mmenuId):Add(pluginInfo.pluginMenuId)
	plug1._ = {name=pluginInfo.pluginMenuId, action=mainActions:Get("runLuaPluginsAction")}
end

function Stop()
	if runForm then runForm:Free() end
	runForm = nil
	mainActions:Get("runLuaPluginsAction"):Free()
	mainMenu:Find(pluginInfo.pluginMenuId):Remove()
end

return pluginInfo

