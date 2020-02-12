-- VCLed 0.1.5
-- ***************************************
-- a VCLua 0.3.5 application
-- Copyright (C) 2006,2010 Hi-Project Ltd.
-- ***************************************
--
_VCLED_NAME = "VCLed"
_VCLED_VERSION = "0.1.5"

package.cpath=package.cpath..";clibs/?.dll;clibs/?.so"

-- for lar packed vcled compatibility
if package.larpath then
   package.larpath=package.larpath..";?.lar;lua/?.lar"
end

require "vcl"

print (VCL._NAME.." v".. VCL._VERSION)
print (_VCLED_NAME.." v".. _VCLED_VERSION.."\n"..VCL._COPYRIGHT)

require "vcled.form"
require "vcled.images"
require "vcled.actions"
require "vcled.font"
require "vcled.editors.installededitors"
require "vcled.menu"
require "vcled.toolbar"
require "vcled.editors"
require "vcled.editors.synedit"
require "vcled.plugins"

function Initialize()	
	Actions.Disable()
	Form.mainToolBar.visible=(Form.mainConfig:GetValue("ShowToolbar")=="true")
	Font.Initialize(Form.mainConfig:GetValue("EditorFont"))
	if (Form.mainConfig:GetValue("RemEdFiles")=="true" and Editors.LoadFileList()) or (arg and arg[1]) then
		for i,v in ipairs(arg) do
			Editors.NewEditor(v)
		end
	else
		Editors.NewEditor(nil)
	end
	Splash.Show()
	Plugins.AutoLoad()	
end

function Run()
	Form.mainForm:ShowModal()
end

function Finalize()
	Editors.SaveFileList()	
	Plugins.Unload()
	Form.mainForm:Free()
end

-- main program
Initialize()
Run()
Finalize()
