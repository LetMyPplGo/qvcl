require "vcl"
require "vcled.common.file"

local VCL,Form,Font,Editors,mainToolbar,Images = VCL,Form,Font,Editors,mainToolbar,Images
local file, tonumber, tostring, string, table, pairs, ipairs = file, tonumber, tostring, string, table, pairs, ipairs 

module "Preferences"

-- General vars
local prefForm = nil
local prefPanel = nil
-- Syntax vars
local comboitems = {"","[fsBold]","[fsItalic]","[fsBold, fsItalic]"}
local synPanel = nil
local inputs = {}
local output = {}

function Show()
	prefForm = VCL.Form()
	prefForm._  = {caption="Preferences", position="pomainformcenter", height=350, width=400, borderstyle="bsdialog" } -- formstyle="fsStayOnTop", }
	
	Page = VCL.PageControl(prefForm)
	Page._ = {Align="alClient",}
	Page["sheet1"] = VCL.TabSheet(Page)
	Page["sheet1"]._ = {caption="General"}
    Page["sheet2"] = VCL.TabSheet(Page)
    Page["sheet2"]._ = {caption="Syntax Highlighting"}
		
	-- general
	prefPanel = VCL.Panel(Page["sheet1"])
	prefPanel._  = {caption="", align="alClient", bevelouter="bvLowered", bevelinner="bvRaised"}
	local prefButPanel = VCL.Panel(Page["sheet1"])
	prefButPanel._  = {caption="", align="alBottom", height=30, bevelouter="bvLovered", bevelinner="bvNone"}	
	VCL.Button(prefButPanel)._ = {caption="Save", left=20, width=100, top=3, onclick="Preferences.onSave"}
	VCL.Button(prefButPanel)._ = {caption="Cancel", left=280, width=100, top=3, onclick="Preferences.onCancel"}
	
	-- syntax
	synPanel = VCL.Panel(Page["sheet2"])
	synPanel._  = {caption="", align="alClient", bevelouter="bvLowered", bevelinner="bvRaised"}
	local synButPanel = VCL.Panel(Page["sheet2"])
	synButPanel._  = {caption="", align="alBottom", height=30, bevelouter="bvLovered", bevelinner="bvNone"}	
	VCL.Button(synButPanel)._ = {caption="Apply", left=20, width=100, top=3, onclick="Preferences.onApply"}
	VCL.Button(synButPanel)._ = {caption="Cancel", left=280, width=100, top=3, onclick="Preferences.onCancel"}
	
	-- General preferences
	BuildGeneralPage(prefPanel)
	-- Syntax preferences
	VCL.Label(synPanel)._ = {caption="Select highlighter type",left=10,top=10}
	synPanel.typeCombo = VCL.ComboBox(synPanel)
	synPanel.typeCombo._ = {autosize=false,left=130,top=8,items="cpp\nfreepascal\nhtml\njava\nlua\nperl\nphp\nsql\ntex\nxml",text="lua",onchange="Preferences.onSynTypeChange"}
	synPanel.scrBox = VCL.ScrollBox(synPanel)
	synPanel.scrBox._ = {top=35,left=5,width=380,height=255}
	BuildSyntaxPage(synPanel.scrBox,"lua")
	
	-- Show
	prefForm:ShowModal()
	prefForm:Free()
end

function BuildGeneralPage(p)
	VCL.Label(p)._ = {caption="Default browser",left=10,top=10}
	VCL.Label(p)._ = {caption="Editor font",left=10,top=40}
	p.prefEdit1 = VCL.FileNameEdit(p)
	p.prefEdit1._ = {filename=Form.mainConfig:GetValue("Browser"),width=260, left=100,top=8}
	p.prefEdit2 = VCL.EditButton(p)
	p.prefEdit2._ = { text=Font.tostring(Font.editorFont.font),width=260, left=100,top=38, readonly=false, autosize=false,
								   image=Images.Load("images/font.png"), onbuttonclick="Preferences.onSelectEditorFont"}
	p.toolbarCB = VCL.CheckBox(p)
	p.toolbarCB._ = {left=100,top=70, caption='Show toolbar', checked=(Form.mainConfig:GetValue("ShowToolbar")=="true")}
	p.fileloadCB = VCL.CheckBox(p)
	p.fileloadCB._ = {left=100,top=100, caption='Remember editor files', checked=(Form.mainConfig:GetValue("RemEdFiles")=="true")}
	p.confirmexitCB = VCL.CheckBox(p)
	p.confirmexitCB._ = {left=100,top=130, caption='Confirmation on exit', checked=(Form.mainConfig:GetValue("ConfirmExit")=="true")}	
	p.loadsynCB = VCL.CheckBox(p)
	p.loadsynCB._ = {left=100,top=160, caption='Load user defined highlighters', checked=(Form.mainConfig:GetValue("LoadSyntax")=="true")}	
end

function BuildSyntaxPage(p,st)
	local syn = file.loadastable("syntax/"..st..".syn")
	if not syn then return end
	local y = 10
	output = {}	
	inputs = {}
	
	for k,v in pairs(syn) do
		local s = nil
		if string.find(v,"(%[)%w") then
			s = string.sub(v,2,-2)
			VCL.Label(p)._= {caption=s,top=y,left=10,font={style="[fsBold]"}}
			y = y + 20
			table.insert(output,v)
		else
			if string.len(v)>0 then
				local a = string.gsub(v,"(%w+)=(-*%w+)","%1")
				if string.upper(a) ~= "STYLEMASK" then
					VCL.Label(p)._= {caption=a,top=y,left=20}
					local b = string.gsub(v,"(%w+)=(-*%w+)","%2")
					if string.upper(a) == "STYLE" then
						local e = VCL.ComboBox(p)
						e._={autosize=false,width=150,top=y,left=120,items=table.concat(comboitems,"\n"),text=comboitems[tonumber(b)+1], onchange="Preferences.onComboChange"}
						table.insert(inputs,e)
					else					
						local e = VCL.EditButton(p)
						e._={autosize=false,width=150,flat=true,image=Images.Load("images/colordialog.png"),text=b,top=y,left=120,color=tonumber(b),onbuttonclick="Preferences.onPickColor"}				
						table.insert(inputs,e)
					end
					y = y + 30
					table.insert(output,v)
				end
			end
		end	
	end
	VCL.Label(p)._= {caption="",top=y}
end

function onSelectEditorFont()
	if Font.editorFont:Execute() then
		prefPanel.prefEdit2.text = Font.tostring(Font.editorFont.font)
		prefPanel.prefEdit2.font = Font.totable(Font.editorFont.font)
		Editors.ChangeEditorFont()
	end
	prefForm:ShowOnTop()
end

function onSynTypeChange(s)
	if not s or not synPanel then return end
	if synPanel.scrBox then
		synPanel.scrBox:Free()
	end
	synPanel.scrBox = VCL.ScrollBox(synPanel)
	synPanel.scrBox._ = {top=35,left=5,width=380,height=255}
	synPanel.scrBox.visible = false
	BuildSyntaxPage(synPanel.scrBox,s.text)
	synPanel.scrBox.visible = true
end

function onPickColor(s)
	local colColor=VCL.ColorDlg() 
	if colColor:Execute() then
		s.color = colColor.color
		s.text = colColor.color
	end                                       
	colColor:Free()
end

function onComboChange(s)
	if not s then return end
	if s.itemindex>0 then s.font = {style=comboitems[s.itemindex+1]} end
end

function onCancel()
	prefForm:Close()
end

function onSave()
	Form.mainConfig:SetValue("Browser",prefPanel.prefEdit1.filename)
	Form.mainConfig:SetValue("EditorFont","Font.editorFont.font="..Font.totablestring(Font.editorFont.font))
	Form.mainConfig:SetValue("ShowToolbar",tostring(prefPanel.toolbarCB.checked))
	Form.mainConfig:SetValue("RemEdFiles",tostring(prefPanel.fileloadCB.checked))
	Form.mainConfig:SetValue("ConfirmExit",tostring(prefPanel.confirmexitCB.checked))
	Form.mainConfig:SetValue("LoadSyntax",tostring(prefPanel.loadsynCB.checked))
	
	-- set current preferences
	Form.mainToolBar.visible = prefPanel.toolbarCB.checked

	prefForm:Close()
end

function onApply()
	local i = 1
	local out = {}
	for k,v in pairs(output) do
		if string.find(v,"(%[)%w") then
			table.insert(out,v)
		else
			local a = string.gsub(v,"(%w+)=(-*%w+)","%1")
			local d = nil 
			if inputs[i].classname=="TLuaComboBox" then
				d = inputs[i].itemindex
			else
				d = inputs[i].text
			end
			table.insert(out,a.."="..tostring(d))
			i = i + 1
		end
	end
	file.save("syntax/"..synPanel.typeCombo.text..".syn",table.concat(out,"\n"))	
end
