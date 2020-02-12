require "vcl"

local VCL,_VCLED_VERSION=VCL,_VCLED_VERSION

module "Form"

-- *******************************************************************
-- mainform
mainForm = VCL.Form("mainform")
mainForm._  = { caption="VCLed v".._VCLED_VERSION, position="podesktopcenter", height=600, width=800, 
				onclosequery="File.CloseQuery", allowdropfiles="true", ondropfiles="File.DropFiles"}

-- mainconfig
mainConfig = VCL.XMLConfig()
mainConfig._ ={rootname = "VCLed", filename = "vcled-config.xml"}

-- statusbar
mainStatusBar = VCL.StatusBar()
mainStatusBar._ = {align="alBottom", height=100} 
for i=1,3 do mainStatusBar:Add(50+100*i/2,"") end

-- toolbar
mainToolBar = VCL.ToolBar()
mainToolBar._ = { showhint=true, borderwidth =0, edgeborders = "[ebLeft,ebTop,ebRight,ebBottom]", edgeinner = "esRaised", edgeouter = "esLowered", autosize = true, buttonwidth = 24, buttonheight = 24, align = alTop, flat = true }

