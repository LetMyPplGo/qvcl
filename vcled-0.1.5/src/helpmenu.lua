require "vcl"
require "vcled.splash"

local VCL,Splash,Editors = VCL,Splash,Editors

local type,file,getfenv = type,file,getfenv

module "Help"

function onAbout()
	Splash.ShowAboutBox()
end

function onHelp()
	VCL.ShowMessage("No help available!")
end

function onContentHelp(w)
	if not (type(w)=="string") then
		w = nil
	end
	local _,_,s = Editors.GetEditor() -- gets current pagesheet
	if s and file.getext(s["fileName"]) then 
		local ext = file.getext(s["fileName"])
		local cf= "check"..ext.."ContentHelp"
		local f = getfenv()[cf]
		if type(f)=="function" and f() then
			cf= ext.."ContentHelp"
			f = getfenv()[cf]
			if f then f(w) end
		end
	else
		VCL.ShowMessage("No content help available!")
	end
end
