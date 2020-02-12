require "vcl"
require "vcled.actions"
require "vcled.font"
require "vcled.common.file"
require "vcled.editors.installededitors"

local file, string, table, os = file, string, table, os
local VCL, Editors, Form, Font, mainActions, InstalledEditors = VCL, Editors, Form, Font, mainActions, InstalledEditors

module "SynEdit"

-- ************************************************
-- Editor Registration 
-- ************************************************
InstalledEditors.SetDefault("SynEdit")
InstalledEditors.Register("SynEdit","*.*","Any files")
InstalledEditors.Register("SynEdit","*.txt","Text files")
InstalledEditors.Register("SynEdit","*.lua","Lua Scripts")
InstalledEditors.Register("SynEdit","*.c;*.cpp;*.h;*.hpp;*.hh","C,C++ files")
InstalledEditors.Register("SynEdit","*.pas","Pascal files")
InstalledEditors.Register("SynEdit","*.java","Java files")
InstalledEditors.Register("SynEdit","*.html;*.htm;*.css","Html files")
InstalledEditors.Register("SynEdit","*.xml;*.xsd;*.dtd;*.xsl;*.xslt","XML files")
InstalledEditors.Register("SynEdit","*.sh;*.csh;*.ksh;*.bash","Unix shell scripts")
InstalledEditors.Register("SynEdit","*.pl;*.pm;*.perl;,*.cgi","Perl scripts")
InstalledEditors.Register("SynEdit","*.php","PHP scripts")
InstalledEditors.Register("SynEdit","*.sql","SQL scripts")
InstalledEditors.Register("SynEdit","*.tex","TEX files")
-- ************************************************

local editorPopupMenu = VCL.PopupMenu()
editorPopupMenu:LoadFromTable({
	{action=mainActions:Get("editUndoAction")},
	{action=mainActions:Get("editRedoAction")},
	{caption="-",},
	{action=mainActions:Get("editCopyAction")},
	{action=mainActions:Get("editCutAction")},
	{action=mainActions:Get("editPasteAction")},
	{caption="-",},
	{action=mainActions:Get("editFindAction")},
	{action=mainActions:Get("editFindNextAction")},
	{action=mainActions:Get("editFindPrevAction")},
	{action=mainActions:Get("editReplaceAction")},
	{caption="-",},
	{action=mainActions:Get("editGotoLineAction")},
})

function New(n, f)
	-- add a new SynEdit to the sheet
	local sheet = Editors.openedPages[n].Sheet
	local ed = VCL.SynEdit(sheet)
	Editors.openedPages[n].Editor = ed
	Editors.openedPages[n].Type = "SynEdit"
	Editors.openedPages[n].FileName = f
	Editors.UID = Editors.UID + 1
	ed._ = {	
			align="alClient", 
			font=Font.totable(Font.editorFont.font),
			popupmenu=editorPopupMenu,
			onchange="SynEdit.onEditorChange",
			oncommandprocessed="SynEdit.onCommandProc",
			onclick="SynEdit.onCommandProc",
			onreplacetext="SynEdit.onReplaceText",
			ondropfiles="SynEdit.onDropFiles",
			onclicklink="SynEditonClickLink",
			onkeydown="SynEdit.onKeyDown",
            tabwidth=5,	
			tag = Editors.UID,
	}
	ed:Clear()
	if f then
	    if file.exists(f) then
			ed:LoadFromFile(f)	
		else
			sheet.caption = sheet.caption.."*" 
		end
		-- set highlighter
		Editors.openedPages[n].HighLighter = ed:SetLang(file.getext(f))
		local ext=file.getext(f)
		if ext and Form.mainConfig:GetValue("LoadSyntax")=="true" then
			local fs = string.lower(string.sub(Editors.openedPages[n].HighLighter.classname,8,-4))
			Editors.openedPages[n].HighLighter:LoadFromFile("syntax/"..fs..".syn")
		end
	end	
	
	onInfo(ed)
end

function onInfo(ed)
	local n = Editors.FindEditor(ed)
	local filename = Editors.openedPages[n].FileName
	local x,y = ed:CaretPos()
	local lc,cc = ed:Info()
	Form.mainStatusBar:Update(1,"Ln:"..y.."  Col:"..x) 
	Form.mainStatusBar:Update(2,"Lines:"..lc.."  Chars:"..cc)
	Form.mainStatusBar:Update(3,filename)
end

function onCommandProc(ed,cmd)
	onInfo(ed)
end

function onEditorChange(ed)
    local n = Editors.FindEditor(ed)
	local s = Editors.openedPages[n].Sheet
	if not string.find(s.caption,"*") then
		s.caption = s.caption.."*"
	end
	onInfo(ed)
end

function onKeyDown(sender, key, shift)
	if key==9 then
		if shift=="[ssShift,ssCtrl]" then
			if Editors.GetIndex()>0 then Editors.SetIndex(Editors.GetIndex()-1) end
		elseif shift=="[ssCtrl]" then
		    if Editors.GetIndex() < table.maxn(Editors.openedPages)-1 then Editors.SetIndex(Editors.GetIndex()+1) end
		end
	end
end

function ProcessCommand(e,cmd)
	e:CommandProcessor(cmd)
end

-- Save
function onSave(e,filename)
	local n = Editors.FindEditor(e)
	local oldext = file.getext(Editors.openedPages[n].FileName)
	local ext = file.getext(filename)
	if oldext ~= ext then
		local h = e:SetLang(ext)
		Editors.openedPages[n].Highlighter = h
	end
	e:SaveToFile(filename)
end

-- Find and Replace
-- TODO
-- implement options "ssoSelectedOnly", "ssoSearchInReplacement", "ssoRegExpr", "ssoRegExprMultiLine"
-- ******************************************************************************
-- Find, FindNext, FindPrev
-- ******************************************************************************

local find = nil
local repl = nil
local ed=nil
local fdir = 0

local function ConvertFindOptions(fnddlg, fwd)
	local fro = fnddlg.options
	local sso = {}
	-- select direction
	if not string.find(fro,"frDown") then fdir=1 else fdir = 0 end
	if fwd then fdir=fwd end
	if fdir==1 then table.insert(sso,"ssoBackwards") end
	-- finddialog options to searchoptions
	if string.find(fro,"frMatchCase") then table.insert(sso,"ssoMatchCase") end
	if string.find(fro,"frWholeWord") then table.insert(sso,"ssoWholeWord") end
	if string.find(fro,"frEntireScope") then table.insert(sso,"ssoEntireScope") end
	return sso
end

function onDialogFind(sender)
	local n = ed:FindReplace(find.FindText,nil,ConvertFindOptions(find),ed:CaretPos())	
	if n>0 then find:CloseDialog() end
end

function onFind(e)
	ed = e
	local s = ed:Get()
	if not find then
		find = VCL.FindDlg()
		find._ = {onfind="SynEdit.onDialogFind"}
		mainActions:Get("editFindNextAction").enabled = true
		mainActions:Get("editFindPrevAction").enabled = true
	end
	find.FindText = s
	find:Execute()
end

function onFindNext(e)
	ed = e
	if ed then
		ed:FindReplace(find.FindText,nil,ConvertFindOptions(find,0),ed:CaretPos())	
	end
end

function onFindPrev(e)
	ed = e
	if ed then
		ed:FindReplace(find.FindText,nil,ConvertFindOptions(find,1),ed:CaretPos())
	end
end

-- ******************************************************************************
-- Replace
-- ******************************************************************************

local function ConvertReplaceOptions()
	local fro = repl.options
	local sso = ConvertFindOptions(repl) -- findoptions of replacedialog
	-- replacedialog options to searchreplaceoptions
	if string.find(fro,"frReplace") then table.insert(sso,"ssoReplace") end
	if string.find(fro,"frReplaceAll") then table.insert(sso,"ssoReplaceAll") end	
	table.insert(sso,"ssoPrompt")  -- SynEdit fires onReplaceText event
	return sso
end

-- called if ssoprompt is set
function onReplaceText(sed,fstr,rstr,x,y,action)
	local fro = repl.options
	if string.find(fro,"frReplaceAll") then 
		action= VCL.MessageDlg("Replace text?","mtConfirmation",{"mbYes","mbNo","mbAll","mbCancel"})
	else
		action= VCL.MessageDlg("Replace text?","mtConfirmation",{"mbYes","mbNo","mbCancel"})
	end
	if action=="mrYes" then
		action="raReplace"
	elseif action=="mrNo" then
		action="raSkip"
	elseif action=="mrCancel" then
		action="raCancel"
	elseif action=="mrAll" then	
		action="raReplaceAll"
	end
	return action
end

function onDialogReplace()	
	local c = ed:FindReplace(repl.FindText,repl.ReplaceText,ConvertReplaceOptions(repl),ed:CaretPos())	
end

function onDialogReplaceFind()
	ed:FindReplace(repl.FindText,nil,ConvertFindOptions(repl),ed:CaretPos())
end

function onReplace(e)
	ed = e
	local s = ed:Get()
	if not repl then
		repl = VCL.ReplaceDlg()
		repl._ = {onfind="SynEdit.onDialogReplaceFind",onreplace="SynEdit.onDialogReplace"}
	end
	repl.FindText = s
	repl:Execute()
end

-- Goto Line
local gotoFrm = nil
function onGotoSelect( )
	ed:GotoLine(gotoFrm.e.value)
	gotoFrm:Close()
end
function onGotoCancel()
	gotoFrm:Close()
end
function onGotoLine(e)
	ed=e
	-- GotoLine form
	gotoFrm=VCL.Form()
	gotoFrm._ = {caption="Goto line", position="pomainformcenter", height=30, width=300, borderstyle="bsdialog"} -- formstyle="fsStayOnTop", 
	VCL.Label(gotoFrm)._ = {caption="Line number:", left=5, top=8}
	gotoFrm.e = VCL.SpinEdit(gotoFrm)	
	gotoFrm.e._ = {left=80, top=5}
	VCL.Button(gotoFrm)._ = {caption="OK", left=140, top=2, default=true, onclick="SynEdit.onGotoSelect"}
	VCL.Button(gotoFrm)._ = {caption="Cancel", left=220, top=2, onclick="SynEdit.onGotoCancel"}
	gotoFrm:ShowModal()
	gotoFrm:Free()
	-- refresh statusbar row position
	onCommandProc(ed,nil)
end

-- Print
function onPrint(e)
	local n = Editors.FindEditor(e)
	local sheet = Editors.openedPages[n].Sheet
	local browser = Form.mainConfig:GetValue("Browser")
	if not file.exists(browser) then
		VCL.MessageDlg("Html browser is invalid. Please correct it on the preferences page!\n\n"..tostring(browser),"mtError",{"mbOk"})
	end
	local f = sheet.caption..".htmp"
	e:SaveToHtml(f,{title=sheet.caption})
	os.execute("\""..browser.."\" "..f)
	os.remove(f)
end